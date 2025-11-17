# frozen_string_literal: true

# app/services/nfe_import_service.rb
require 'nokogiri'

class NfeImportService
  # .call agora aceita o usuário
  def self.call(file, user)
    new(file, user).import
  end

  def initialize(file, user)
    @file = file
    @user = user
  end

  def import
    doc = Nokogiri::XML(@file.read)
    doc.remove_namespaces!

    infNFe = doc.at_xpath('//infNFe')
    raise 'Invalid NF-e XML: <infNFe> tag not found.' unless infNFe

    # 1. Parsear todos os blocos de dados do cabeçalho
    ide     = infNFe.at_xpath('ide')
    emit    = infNFe.at_xpath('emit')
    dest    = infNFe.at_xpath('dest')
    transp  = infNFe.at_xpath('transp') # Bloco de transporte
    total   = infNFe.at_xpath('total/ICMSTot')

    # 2. Processar os ITENS PRIMEIRO para coletar dados para concatenação
    item_nodes = infNFe.xpath('det')

    cfops       = []
    csts        = []
    ncms        = []
    descricoes  = []
    item_attributes = [] # Array para criar os item_notas de uma vez

    item_nodes.each do |node|
      prod    = node.at_xpath('prod')
      imposto = node.at_xpath('imposto') # Precisamos disto para o CST

      # Adiciona dados aos arrays para concatenação
      cfops       << prod.at_xpath('CFOP')&.text
      csts        << imposto.at_xpath('ICMS/*[1]/CST')&.text # XPath complexo para pegar o CST
      ncms        << prod.at_xpath('NCM')&.text
      descricoes  << prod.at_xpath('xProd')&.text

      # Prepara os atributos para os 'item_notas'
      item_attributes << {
        item_number: node['nItem'].to_i,
        product_code: prod.at_xpath('cProd')&.text,
        description: prod.at_xpath('xProd')&.text,
        quantity: prod.at_xpath('qCom')&.text&.to_f,
        unit_price: prod.at_xpath('vUnCom')&.text&.to_f,
        total_price: prod.at_xpath('vProd')&.text&.to_f
      }
    end

    # Limpar valores nulos dos arrays
    cfops.compact!
    csts.compact!
    ncms.compact!
    descricoes.compact!

    # 3. Criar o sumário de impostos para o campo 'impostos' (NOT NULL)
    impostos_summary = [
      "ICMS: #{total.at_xpath('vICMS')&.text || '0.00'}",
      "IPI: #{total.at_xpath('vIPI')&.text || '0.00'}",
      "PIS: #{total.at_xpath('vPIS')&.text || '0.00'}",
      "COFINS: #{total.at_xpath('vCOFINS')&.text || '0.00'}"
    ].join(', ')

    nota = nil
    NotaFiscal.transaction do
      # 4. Criar o registro NotaFiscal (pai) com TODOS os campos NOT NULL
      nota = @user.nota_fiscais.create!(
        # --- Campos do Service Original (mapeados por alias) ---
        access_key: infNFe['Id'].gsub('NFe', ''),
        number: ide.at_xpath('nNF')&.text,
        series: ide.at_xpath('serie')&.text,
        emission_date: ide.at_xpath('dEmi')&.text,
        emitter_name: emit.at_xpath('xNome')&.text,
        emitter_cnpj: emit.at_xpath('CNPJ')&.text,
        recipient_name: dest.at_xpath('xNome')&.text,
        recipient_cnpj: dest.at_xpath('CNPJ')&.text,
        total_value: total.at_xpath('vNF')&.text&.to_f,
        products_value: total.at_xpath('vProd')&.text&.to_f,

        # --- Campos Redundantes (NOT NULL) ---
        cliente: dest.at_xpath('xNome')&.text,
        valor: total.at_xpath('vNF')&.text&.to_f,

        # --- Campos de Cabeçalho Faltantes (NOT NULL) ---
        natureza_operacao: ide.at_xpath('natOp')&.text,
        transportadora: transp&.at_xpath('transporta/xNome')&.text || 'Sem Transportadora',

        # --- Campos Concatenados (NOT NULL) ---
        cfop: cfops.uniq.join(', '),
        cst: csts.uniq.join(', '),
        ncm: ncms.uniq.join(', '),
        descricao_produtos: descricoes.join('; '),

        # --- Campo de Sumário (NOT NULL) ---
        impostos: impostos_summary
      )

      # 5. Agora, criar os 'item_notas' (filhos) associados
      # Usamos 'create!' para garantir que qualquer falha aqui
      # também reverta a criação da NotaFiscal (graças à transação)
      nota.item_notas.create!(item_attributes)
    end # Fim da transação

    nota
  end
end
