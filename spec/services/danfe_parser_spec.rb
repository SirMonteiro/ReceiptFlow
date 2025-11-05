# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DanfeParser do
  describe '#parse' do
    it 'extracts the invoice number (nNF) from the XML' do
      xml_content = <<-XML
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <nNF>12345</nNF>
              </ide>
            </infNFe>
          </NFe>
        </nfeProc>
      XML

      parser = described_class.new(xml_content)
      result = parser.parse

      expect(result[:invoice_number]).to eq('12345')
    end
  end
end
