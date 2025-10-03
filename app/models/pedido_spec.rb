require 'rails_helper'

RSpec.describe Pedido, type: :model do
    it "é válido com cliente e valor" do
        pedido = Pedido.new(cliente: "Maria", valor: 100.50)
        expect(pedido).to be_valid
    end

    it "não é válido sem cliente" do
        pedido = Pedido.new(valor: 100.50)
        expect(pedido).not_to be_valid
    end

    it "não é válido sem valor" do
        pedido = Pedido.new(cliente: "Maria")
        expect(pedido).not_to be_valid
    end
end