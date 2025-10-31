require 'rails_helper'

RSpec.describe "NotasFiscais", type: :request do
  let(:file) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/NFe_assinada.xml'),
      'text/xml'
    )
  end

  before(:each) do
    NotaFiscal.destroy_all
    ItemNota.destroy_all
    file.rewind
  end

  describe "POST /notas_fiscais/import" do
    it "imports the XML and redirects to the index page with a notice" do
      expect {
        post import_notas_fiscais_path, params: { xml_file: file }
      }.to change(NotaFiscal, :count).by(1)

      expect(response).to redirect_to(notas_fiscais_path)
      expect(flash[:notice]).to start_with("Successfully imported NF-e")
    end

    it "handles cases where no file is uploaded" do
      expect {
        post import_notas_fiscais_path, params: { xml_file: nil }
      }.to_not change(NotaFiscal, :count)

      expect(NotaFiscal.count).to eq(0)
      expect(response).to redirect_to(notas_fiscais_path)
      expect(flash[:alert]).to eq("No file selected. Please choose an XML file.")
    end
  end
end