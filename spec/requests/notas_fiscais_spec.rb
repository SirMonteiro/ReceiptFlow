require 'rails_helper'

RSpec.describe "NotasFiscais", type: :request do
  let(:file) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/NFe_assinada.xml'),
      'text/xml'
    )
  end

  # --- ADIÇÃO 1: Criar o usuário de teste ---
  let(:user) do
    User.create!(
      nome: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before(:each) do
    NotaFiscal.destroy_all
    ItemNota.destroy_all
    file.rewind
  end

  describe "POST /notas_fiscais/import" do
    it "imports the XML and redirects to the index page with a notice" do
      # --- ADIÇÃO 2: Simular o login ANTES do teste ---
      # (Isto assume que 'login_path' é a sua rota de 'sessions#create')
      post sessions_path, params: { email: user.email, password: "password123" }
      # Opcional: verificar se o login funcionou
      expect(response).to redirect_to(home_path) 
      
      # --- Agora o 'current_user' existe e o teste de importação pode rodar ---
      expect {
        post import_notas_fiscais_path, params: { xml_file: file }
      }.to change(NotaFiscal, :count).by(1)

      expect(response).to redirect_to(notas_fiscais_path)
      expect(flash[:notice]).to start_with("NF-e ")
    end

    it "handles cases where no file is uploaded" do
      expect {
        post import_notas_fiscais_path, params: { xml_file: nil }
      }.to_not change(NotaFiscal, :count)

      expect(NotaFiscal.count).to eq(0)
      expect(response).to redirect_to(notas_fiscais_path)
      
      # --- CORREÇÃO: Mudar para a mensagem em Português ---
      expect(flash[:alert]).to eq("Nenhum arquivo selecionado. Por favor escolha um arquivo XML.")
    end
  end
end