require 'rails_helper'

RSpec.describe Pedido, type: :model do
  describe 'validações básicas' do
    it 'é válido com cliente e valor' do
      pedido = Pedido.new(cliente: 'Teste', valor: 123.45)
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
