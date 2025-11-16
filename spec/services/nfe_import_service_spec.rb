# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NfeImportService do
  let(:file) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/NFe_assinada.xml'),
      'text/xml'
    )
  end

  before do
    NotaFiscal.destroy_all
    ItemNota.destroy_all
    file.rewind
  end

  context 'with a valid NF-e XML file' do
    it 'creates a new NotaFiscal record' do
      expect do
        described_class.call(file)
      end.to change(NotaFiscal, :count).by(1)
    end

    it 'creates the associated ItemNota records' do
      expect do
        described_class.call(file)
      end.to change(ItemNota, :count).by(2)
    end

    it 'correctly populates the NotaFiscal attributes' do
      nota = described_class.call(file)
      expect(nota.access_key).to eq('35080599999090910270550010000000015180051273')
      expect(nota.number).to eq(1)
      expect(nota.emitter_name).to eq('NF-e Associacao NF-e')
    end

    it 'correctly populates the first ItemNota attributes' do
      nota = described_class.call(file)
      item = nota.item_notas.first
      expect(item.item_number).to eq(1)
      expect(item.description).to eq('Agua Mineral')
    end

    it 'is wrapped in a transaction and rolls back on failure' do
      described_class.call(file)

      nota_count_before = NotaFiscal.count
      item_count_before = ItemNota.count

      file.rewind

      expect do
        described_class.call(file)
      end.to raise_error(ActiveRecord::RecordInvalid)

      nota_count_after = NotaFiscal.count
      item_count_after = ItemNota.count

      expect(nota_count_after).to eq(nota_count_before)
      expect(item_count_after).to eq(item_count_before)
    end
  end
end
