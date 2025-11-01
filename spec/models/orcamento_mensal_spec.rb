require 'rails_helper'

RSpec.describe OrcamentoMensal, type: :model do
    let(:user) { User.create!(nome: "usuarilson", email: "usuarilson@usuarilson.com", password: "123456") }

    context "validações básicas" do
        it "é válido com mês, ano, valor e user" do
            orcamento = OrcamentoMensal.new(mes: 5, ano: 2025, valor: 1000, user: user)
            expect(orcamento).to be_valid
        end

        it "é inválido sem mês" do
            orcamento = OrcamentoMensal.new(ano: 2025, valor: 1000, user: user)
            expect(orcamento).to be_invalid
        end

        it "é inválido com mês fora de 1..12" do
            orcamento = OrcamentoMensal.new(mes: 13, ano: 2025, valor: 1000, user: user)
            expect(orcamento).to be_invalid
            expect(orcamento.errors[:mes]).to include("o mês deve ser válido")
        end

        it "é inválido com valor negativo" do
            orcamento = OrcamentoMensal.new(mes: 3, ano: 2025, valor: -50, user: user)
            expect(orcamento).to be_invalid
        end
    end

  context "unicidade" do
    it "não permite dois orçamentos para o mesmo mês, ano e usuário" do
      OrcamentoMensal.create!(mes: 5, ano: 2025, valor: 500, user: user)
      duplicada = OrcamentoMensal.new(mes: 5, ano: 2025, valor: 800, user: user)

      expect(duplicada).to be_invalid
      expect(duplicada.errors[:mes]).to include("has already been taken")
    end
  end

end