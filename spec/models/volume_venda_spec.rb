# frozen_string_literal: true

require 'rails_helper'
require 'bigdecimal'

RSpec.describe VolumeVenda, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:volume_venda)).to be_valid
    end

    it 'is invalid without loja' do
      volume = build(:volume_venda, loja: nil)
      expect(volume).not_to be_valid
      expect(volume.errors[:loja]).to include("can't be blank")
    end

    it 'is invalid when data_final is before data_inicial' do
      volume = build(:volume_venda, data_inicial: Date.new(2025, 1, 31), data_final: Date.new(2025, 1, 1))
      expect(volume).not_to be_valid
      expect(volume.errors[:data_final]).to include('deve ser posterior ou igual à data inicial')
    end

    it 'is invalid when valor_total is negative' do
      volume = build(:volume_venda, valor_total: -10)
      expect(volume).not_to be_valid
      expect(volume.errors[:valor_total]).to include('não pode ser negativo')
    end

    it 'is invalid when quantidade_notas is negative' do
      volume = build(:volume_venda, quantidade_notas: -1)
      expect(volume).not_to be_valid
      expect(volume.errors[:quantidade_notas]).to include('não pode ser negativa')
    end

    it 'calculates ticket_medio automatically when not provided' do
      volume = build(:volume_venda, valor_total: 3000.0, quantidade_notas: 3, ticket_medio: nil)
      expect(volume).to be_valid
      expect(volume.ticket_medio).to eq(BigDecimal('1000.0'))
    end
  end

  describe '.por_periodo' do
    let(:user) { create(:user) }
    let(:data_inicial) { Date.new(2025, 1, 1) }
    let(:data_final) { Date.new(2025, 1, 31) }

    before do
      create(:danfe,
             user: user,
             valor: 1500,
             data_saida: Date.new(2025, 1, 5),
             remetente: { razao_social: 'Loja Centro', cnpj: '12345678000195' }.to_json,
             valores_totais: 1500,
             impostos: { icms: 18.0, ipi: 5.0 }.to_json)

      create(:danfe,
             user: user,
             valor: 500,
             data_saida: Date.new(2025, 1, 15),
             remetente: { razao_social: 'Loja Centro', cnpj: '12345678000195' }.to_json,
             valores_totais: 500,
             impostos: { icms: 18.0, ipi: 5.0 }.to_json)

      create(:danfe,
             user: user,
             valor: 2500,
             data_saida: Date.new(2025, 1, 20),
             remetente: { razao_social: 'Loja Norte', cnpj: '98765432000195' }.to_json,
             valores_totais: 2500,
             impostos: { icms: 18.0, ipi: 5.0 }.to_json)

      create(:danfe,
             user: user,
             valor: 700,
             data_saida: Date.new(2025, 2, 2),
             remetente: { razao_social: 'Loja Norte', cnpj: '98765432000195' }.to_json,
             valores_totais: 700,
             impostos: { icms: 18.0, ipi: 5.0 }.to_json)
    end

    it 'aggregates danfes totals by loja within the period' do
      resultado = described_class.por_periodo(data_inicial: data_inicial, data_final: data_final,
                                              danfes: Danfe.where(user: user))

      expect(resultado.map(&:loja)).to contain_exactly('Loja Centro', 'Loja Norte')

      centro = resultado.find { |volume| volume.loja == 'Loja Centro' }
      expect(centro.valor_total).to eq(BigDecimal('2000.0'))
      expect(centro.quantidade_notas).to eq(2)
      expect(centro.ticket_medio).to eq(BigDecimal('1000.0'))
      expect(centro.cnpj).to eq('12345678000195')
      expect(centro.data_inicial).to eq(data_inicial)
      expect(centro.data_final).to eq(data_final)
      expect(centro).not_to be_persisted

      norte = resultado.find { |volume| volume.loja == 'Loja Norte' }
      expect(norte.valor_total).to eq(BigDecimal('2500.0'))
      expect(norte.quantidade_notas).to eq(1)
      expect(norte.ticket_medio).to eq(BigDecimal('2500.0'))
    end

    it 'ignores danfes outside the period' do
      resultado = described_class.por_periodo(data_inicial: data_inicial, data_final: data_final,
                                              danfes: Danfe.where(user: user))
      nomes = resultado.map(&:loja)
      expect(nomes).not_to be_empty
      expect(nomes).to include('Loja Norte')
      expect(resultado.find { |volume| volume.loja == 'Loja Norte' }.valor_total).to eq(BigDecimal('2500.0'))
    end

    it 'retorna coleção vazia quando não existem notas no período' do
      vazio = described_class.por_periodo(
        data_inicial: Date.new(2024, 3, 1),
        data_final: Date.new(2024, 3, 31),
        danfes: Danfe.where(user: user)
      )

      expect(vazio).to eq([])
    end

    it 'raises ArgumentError when the date range is invalid' do
      expect do
        described_class.por_periodo(data_inicial: data_final, data_final: data_inicial.prev_day,
                                    danfes: Danfe.where(user: user))
      end.to raise_error(ArgumentError)
    end
  end
end
