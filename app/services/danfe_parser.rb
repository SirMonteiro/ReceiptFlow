# frozen_string_literal: true

require 'nokogiri'

class DanfeParser
  def initialize(xml_content)
    @doc = Nokogiri::XML(xml_content)
    @doc.remove_namespaces!
  end

  def parse
    {
      invoice_number: @doc.at_xpath('//ide/nNF')&.text
    }
  end
end
