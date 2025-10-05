require 'rails_helper'

RSpec.describe Pedido, type: :model do
  describe 'validações básicas' do
    it 'é válido com todos os campos obrigatórios preenchidos' do
      pedido = Pedido.new(
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
        data_saida: Date.today
      )
      expect(pedido).to be_valid
    end

    it 'não é válido sem cliente' do
      pedido = Pedido.new(valor: 123.45)
      expect(pedido).not_to be_valid
    end

    it 'não é válido sem valor' do
      pedido = Pedido.new(cliente: 'Teste')
      expect(pedido).not_to be_valid
    end
  end
end
