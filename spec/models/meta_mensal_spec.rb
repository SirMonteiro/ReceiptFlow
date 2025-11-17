# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetaMensal, type: :model do
  let(:user) { User.create!(nome: 'usuarilson', email: 'usuarilson@usuarilson.com', password: '123456') }

  context 'validações básicas' do
    it 'é válido com mês, ano, valor_meta e user' do
      meta = described_class.new(mes: 5, ano: 2025, valor_meta: 1000, user: user)
      expect(meta).to be_valid
    end

    it 'é inválido sem mês' do
      meta = described_class.new(ano: 2025, valor_meta: 1000, user: user)
      expect(meta).to be_invalid
    end

    it 'é inválido com mês fora de 1..12' do
      meta = described_class.new(mes: 13, ano: 2025, valor_meta: 1000, user: user)
      expect(meta).to be_invalid
      expect(meta.errors[:mes]).to include('o mês deve ser válido')
    end

    it 'é inválido com valor negativo' do
      meta = described_class.new(mes: 3, ano: 2025, valor_meta: -50, user: user)
      expect(meta).to be_invalid
    end
  end

  context 'unicidade' do
    it 'não permite duas metas para o mesmo mês, ano e usuário' do
      described_class.create!(mes: 5, ano: 2025, valor_meta: 500, user: user)
      duplicada = described_class.new(mes: 5, ano: 2025, valor_meta: 800, user: user)

      expect(duplicada).to be_invalid
      expect(duplicada.errors[:mes]).to include('has already been taken')
    end
  end
end
