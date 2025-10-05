# app/services/danfe_parser.rb
require 'nokogiri'

class DanfeParser
  def initialize(xml_content)
    @doc = Nokogiri::XML(xml_content)
    @doc.remove_namespaces! # This is important for simplifying XML parsing
  end

  def parse
    {
      invoice_number: @doc.at_xpath("//ide/nNF")&.text
    }
  end
end