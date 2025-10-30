require "rails_helper"

RSpec.describe "DanfesController", type: :request do
  let!(:user) { User.create!(nome: "Gerente", email: "gerente@exemplo.com", password: "senha123") }
  before { sign_in user }

  describe "GET /filter" do
    context "quando o intervalo de datas é válido" do
      it "redireciona para a rota de resultados com as datas" do
        params = { data_inicial: "2024-01-01", data_final: "2024-12-31" }
        get filter_danfes_path, params: params

        expect(response).to redirect_to(result_danfes_path(params))
      end
    end

    context "quando o intervalo de datas é inválido" do
      it "retorna erro ou redireciona com aviso" do
        get filter_danfes_path, params: { data_inicial: "2024-12-31", data_final: "2024-01-01" }
        expect(response).to redirect_to(filter_danfes_path)
        expect(flash[:alert]).to eq("Intervalo de datas inválido. Verifique as datas e tente novamente.")
      end
    end
  end
end