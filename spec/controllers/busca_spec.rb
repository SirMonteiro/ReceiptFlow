require 'rails_helper'

RSpec.describe "Buscas", type: :request do
  let!(:arara_azul) { create(:cliente, descricao: "Azuis") }
  let!(:flamingo_vermelho) { create(:cliente, descricao: "Vermelhos") }
  describe "GET /busca" do
    it "Retorna com sucesso" do
      get busca_path
      expect(response).to have_http_status(:success)
    end

    it "Renderiza a página de busca" do
      get busca_path
      expect(response.body).to include("Busca")
    end

    context "Com uma pesquisa" do
      let!(:resultado) { create(:cliente, codigo: "1234567890", descricao: "Vermelhos") }

      it "retorna resultados" do
        get busca_path, params: { query: "Vermelhos" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(resultado.descricao)
        expect(response.body).to include("Resultados para")
      end


      it "ignora capitalização" do
        get busca_path, params: { query: "vermelhos" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(resultado.descricao)
      end
    end

    context "pesquisa vazia" do
      it "lida corretamente com parâmetro de pesquisa vazio" do
        get busca_path, params: { query: "" }

        expect(response).to have_http_status(:success)
        expect(response.body).not_to include("Resultados para")
      end
    end

    context "pesquisa inexistente" do
      it "não devolve nenhum resultado" do
        get busca_path, params: { query: "xyznonexistent123" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Nenhum resultado encontrado.")
      end
    end
  end
end
