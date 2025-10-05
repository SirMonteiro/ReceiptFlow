# spec/services/danfe_parser_spec.rb
require 'rails_helper'

RSpec.describe DanfeParser do
  describe "#parse" do
    it "extracts the invoice number (nNF) from the XML" do
      # --- 1. Setup ---
      # A minimal sample of the XML structure
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

      # --- 2. Action ---
      # We call the 'parse' method on our (not yet existing) class
      parser = DanfeParser.new(xml_content)
      result = parser.parse

      # --- 3. Expectation ---
      # We expect the result to be a hash containing the invoice number
      expect(result[:invoice_number]).to eq("12345")
    end
  end
end