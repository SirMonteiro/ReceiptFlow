# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pedido, type: :model do
  describe 'validações básicas' do
    it 'é válido com todos os campos obrigatórios preenchidos' do
      pedido = described_class.new(
        cliente: 'Teste',
        valor: 123.45,
        chave_acesso: '12345678901234567890123456789012345678901234',
        natureza_operacao: 'Venda',
        remetente: 'Empresa X',
        destinatario: 'Cliente Y',
        descricao_produtos: 'Produto A, Produto B',
        valores_totais: 150.75,
        impostos: 15.75,
        cfop: '5102',
        cst: '060',
        ncm: '12345678',
        transportadora: 'Transportadora Z',
        data_saida: Time.zone.today
      )
      expect(pedido).to be_valid
    end

    it 'não é válido sem cliente' do
      pedido = described_class.new(valor: 123.45)
      expect(pedido).not_to be_valid
    end

    it 'não é válido sem valor' do
      pedido = described_class.new(cliente: 'Teste')
      expect(pedido).not_to be_valid
    end
  end

  describe 'métodos de faturamento' do
    let(:pedido_jan) do
      described_class.new(
        cliente: 'Cliente A',
        valor: 500.75,
        chave_acesso: '12345678901234567890123456789012345678901234',
        natureza_operacao: 'Venda',
        remetente: { razao_social: 'Empresa X' },
        destinatario: { razao_social: 'Cliente A Corp' },
        descricao_produtos: [{ nome: 'Produto 1' }],
        valores_totais: 500.75,
        impostos: { icms: 90.0 },
        cfop: '5102',
        cst: '060',
        ncm: '12345678',
        transportadora: { razao_social: 'Transportadora Z' },
        data_saida: Time.zone.local(2025, 1, 15)
      )
    end

    let(:pedido_jan_2) do
      described_class.new(
        cliente: 'Cliente B',
        valor: 750.25,
        chave_acesso: '09876543210987654321098765432109876543210987',
        natureza_operacao: 'Venda',
        remetente: { razao_social: 'Empresa X' },
        destinatario: { razao_social: 'Cliente B Ltda' },
        descricao_produtos: [{ nome: 'Produto 2' }],
        valores_totais: 750.25,
        impostos: { icms: 135.0 },
        cfop: '5102',
        cst: '060',
        ncm: '87654321',
        transportadora: { razao_social: 'Transportadora W' },
        data_saida: Time.zone.local(2025, 1, 20)
      )
    end

    let(:pedido_fev) do
      described_class.new(
        cliente: 'Cliente A',
        valor: 1250.50,
        chave_acesso: '13579246801357924680135792468013579246801357',
        natureza_operacao: 'Venda',
        remetente: { razao_social: 'Empresa X' },
        destinatario: { razao_social: 'Cliente A Corp' },
        descricao_produtos: [{ nome: 'Produto 3' }],
        valores_totais: 1250.50,
        impostos: { icms: 225.0 },
        cfop: '5102',
        cst: '060',
        ncm: '23456789',
        transportadora: { razao_social: 'Transportadora Y' },
        data_saida: Time.zone.local(2025, 2, 5)
      )
    end

    describe '.faturamento_por_mes' do
      it 'agrupa corretamente o faturamento por mês' do
        pedidos = [pedido_jan, pedido_jan_2, pedido_fev]
        resultado = described_class.faturamento_por_mes(pedidos)

        expect(resultado['Janeiro/2025']).to eq(1251.0)
        expect(resultado['Fevereiro/2025']).to eq(1250.50)
      end

      it 'retorna hash vazio quando não há pedidos' do
        expect(described_class.faturamento_por_mes([])).to eq({})
      end
    end

    describe '.faturamento_por_cliente' do
      it 'agrupa corretamente o faturamento por cliente' do
        pedidos = [pedido_jan, pedido_jan_2, pedido_fev]
        resultado = described_class.faturamento_por_cliente(pedidos)

        expect(resultado['Cliente A']).to eq(1751.25)
        expect(resultado['Cliente B']).to eq(750.25)
      end

      it 'retorna hash vazio quando não há pedidos' do
        expect(described_class.faturamento_por_cliente([])).to eq({})
      end
    end
  end
end
