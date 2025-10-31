require 'rails_helper'

RSpec.describe Despesa, type: :model do
    let(:user) { User.create!(nome: "usuarilson", email: "usuarilson@usuarilson.com", password: "123456") }

    context "validações básicas" do
        it "é válido com user, valor e data" do
            despesa = Despesa.new(valor: 1000, data: Time.new(2025, 2, 5), user: user)
            expect(despesa).to be_valid
        end

        it "é inválido sem valor" do
            despesa = Despesa.new(data: Time.new(2025, 2, 5), user: user)
            expect(despesa).to be_invalid
        end

        it "é inválido sem data" do
            despesa = Despesa.new(valor: 1000, user: user)
            expect(despesa).to be_invalid
        end

        it "é inválido com valor negativo" do
            despesa = Despesa.new(valor: -1000, data: Time.new(2025, 2, 5), user: user)
            expect(despesa).to be_invalid
        end
    end

end