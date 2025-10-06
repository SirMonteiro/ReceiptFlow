require 'rails_helper'

RSpec.describe Cliente, type: :model do
  describe ".search" do
    let!(:arara_azul) { create(:cliente, descricao: 'Arara Azul') }
    let!(:flamingo_vermelho) { create(:cliente, descricao: "Flamingo Vermelho") }

    context "quando pesquisando descricao" do
      it "acha a nota correspondente" do
        resultado = Cliente.search_full_text("Ara")
        expect(resultado.pluck(:descricao)).to include(arara_azul.descricao)
      end
    end

    context "ignora a capitalizacao" do
      it "e acha a nota apesar de estar tudo minúsculo" do
        resultado = Cliente.search_full_text("azul")

        expect(resultado.pluck(:descricao)).to include(arara_azul.descricao)
        expect(resultado.pluck(:descricao)).not_to include(flamingo_vermelho.descricao)
      end

      it "acha a nota apesar de estar tudo maiúsculo" do
        resultado = Cliente.search_full_text("AZUL")

        expect(resultado.pluck(:descricao)).to include(arara_azul.descricao)
      end
    end

    context "mesmo a pesquisa parcialmente escrita" do
      it "acha a nota parcialmente correspondente" do
        resultado = Cliente.search_full_text("Ara")

        expect(resultado.pluck(:descricao)).to include(arara_azul.descricao)
      end
    end

    context "sem nenhuma correspondencia" do
      it "devolve uma colecao vazia" do
        resultado = Cliente.search_full_text("nonexistent")

        expect(resultado).to be_empty
      end
    end

    context "com uma pesquisa nula" do
      it "nao levanta erros" do
        expect { Cliente.search_full_text(nil) }.not_to raise_error
      end
    end
  end
end
