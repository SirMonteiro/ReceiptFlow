# app/services/nfe_import_service.rb
require 'nokogiri'

class NfeImportService
  # We no longer need the namespace constant, since we're removing them.

  # .call is a common pattern for service objects
  def self.call(file)
    new(file).import
  end

  def initialize(file)
    @file = file
  end

  def import
    doc = Nokogiri::XML(@file.read)
    
    # This is the key: remove all namespaces to simplify XPath
    doc.remove_namespaces! 

    # Find the main <infNFe> tag (now without the 'nfe:' prefix)
    infNFe = doc.at_xpath('//infNFe')
    unless infNFe
      raise "Invalid NF-e XML: <infNFe> tag not found."
    end
    
    # Find other key sections (all without the 'nfe:' prefix)
    ide = infNFe.at_xpath('ide')
    emit = infNFe.at_xpath('emit')
    dest = infNFe.at_xpath('dest')
    total = infNFe.at_xpath('total/ICMSTot')
    
    nota = nil
    NotaFiscal.transaction do
      # 1. Create the main NotaFiscal record
      nota = NotaFiscal.create!(
        access_key:     infNFe['Id'].gsub('NFe', ''),
        number:         ide.at_xpath('nNF')&.text,
        series:         ide.at_xpath('serie')&.text,
        emission_date:  ide.at_xpath('dEmi')&.text,
        emitter_name:   emit.at_xpath('xNome')&.text,
        emitter_cnpj:   emit.at_xpath('CNPJ')&.text,
        recipient_name: dest.at_xpath('xNome')&.text,
        recipient_cnpj: dest.at_xpath('CNPJ')&.text,
        total_value:    total.at_xpath('vNF')&.text&.to_f,
        products_value: total.at_xpath('vProd')&.text&.to_f
      )

      # 2. Extract Item-level Data (all without 'nfe:')
      item_nodes = infNFe.xpath('det')
      
      item_nodes.each do |node|
        prod = node.at_xpath('prod')
        if prod
          # Create the associated item
          nota.item_notas.create!(
            item_number:  node['nItem'].to_i,
            product_code: prod.at_xpath('cProd')&.text,
            description:  prod.at_xpath('xProd')&.text,
            quantity:     prod.at_xpath('qCom')&.text&.to_f,
            unit_price:   prod.at_xpath('vUnCom')&.text&.to_f,
            total_price:  prod.at_xpath('vProd')&.text&.to_f
          )
        end
      end
    end # End of the transaction

    # Return the newly created invoice
    return nota
  end
end