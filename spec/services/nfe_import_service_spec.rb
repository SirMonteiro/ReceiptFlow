require 'rails_helper'

RSpec.describe NfeImportService do
  let(:file) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/NFe_assinada.xml'),
      'text/xml'
    )
  end
  
  # --- ADIÇÃO 1: Crie um usuário de teste ---
  # (Ajuste se o seu modelo User.create! precisar de mais campos)
  let(:user) do
    User.create!(
      nome: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before(:each) do
    # Limpa os dados antes de CADA teste 'it'
    NotaFiscal.destroy_all
    ItemNota.destroy_all
    file.rewind
  end

  context "with a valid NF-e XML file" do
    it "creates a new NotaFiscal record" do
      expect {
        # --- ADIÇÃO 2: Passe o 'user' ---
        described_class.call(file, user)
      }.to change(NotaFiscal, :count).by(1)
    end

    it "creates the associated ItemNota records" do
      expect {
        # --- ADIÇÃO 3: Passe o 'user' ---
        described_class.call(file, user)
      }.to change(ItemNota, :count).by(2)
    end

    it "correctly populates the NotaFiscal attributes" do
      # --- ADIÇÃO 4: Passe o 'user' ---
      nota = described_class.call(file, user)
      
      expect(nota.access_key).to eq("35080599999090910270550010000000015180051273")
      expect(nota.number).to eq(1)
      expect(nota.emitter_name).to eq("NF-e Associacao NF-e")
      # Adicione mais 'expects' para os novos campos (cfop, cliente, etc.) se quiser
    end

    it "correctly populates the first ItemNota attributes" do
      # --- ADIÇÃO 5: Passe o 'user' ---
      nota = described_class.call(file, user)
      item = nota.item_notas.first
      
      expect(item.item_number).to eq(1)
      expect(item.description).to eq("Agua Mineral")
    end
    
    # Este teste verifica se a transação funciona.
    # Ele importa o mesmo arquivo duas vezes.
    # A segunda vez falha (chave de acesso duplicada), e o teste
    # verifica se NADA novo foi criado nessa segunda tentativa.
    it "is wrapped in a transaction and rolls back on failure" do
      # --- ADIÇÃO 6: Passe o 'user' (na primeira chamada) ---
      described_class.call(file, user)
      
      nota_count_before = NotaFiscal.count
      item_count_before = ItemNota.count

      file.rewind 

      expect {
        # --- ADIÇÃO 7: Passe o 'user' (na segunda chamada, que falha) ---
        described_class.call(file, user)
      }.to raise_error(ActiveRecord::RecordInvalid) # Falha por chave duplicada

      nota_count_after = NotaFiscal.count
      item_count_after = ItemNota.count

      # Verifica se os contadores não mudaram após a falha
      expect(nota_count_after).to eq(nota_count_before)
      expect(item_count_after).to eq(item_count_before)
    end
  end
end