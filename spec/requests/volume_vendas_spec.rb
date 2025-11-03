require "rails_helper"

RSpec.describe "VolumeVendas", type: :request do
  let(:user) { create(:user) }
  let(:data_inicial) { "2025-01-01" }
  let(:data_final) { "2025-01-31" }

  describe "GET /volume_vendas" do
    it "redirects to login when not authenticated" do
      get volume_vendas_path
      expect(response).to redirect_to(new_session_path)
      expect(flash[:alert]).to eq("Você precisa estar logado para acessar essa página.")
    end

    context "when authenticated" do
      before { sign_in(user) }

      it "renders a successful response with aggregated data" do
        create(:danfe,
          user: user,
          valor: 1500,
          data_saida: Date.new(2025, 1, 5),
          remetente: { razao_social: "Loja Centro", cnpj: "12345678000195" }.to_json,
          valores_totais: 1500,
          impostos: { icms: 18.0, ipi: 5.0 }.to_json)

        create(:danfe,
          user: user,
          valor: 2500,
          data_saida: Date.new(2025, 1, 20),
          remetente: { razao_social: "Loja Norte", cnpj: "98765432000195" }.to_json,
          valores_totais: 2500,
          impostos: { icms: 18.0, ipi: 5.0 }.to_json)

        get volume_vendas_path, params: { data_inicial: data_inicial, data_final: data_final }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Loja Centro")
        expect(response.body).to include("Loja Norte")
        expect(response.body).to include("R$ 1.500,00")
        expect(response.body).to include("R$ 2.500,00")
      end

      it "retorna mensagem de alerta para intervalo inválido" do
        get volume_vendas_path, params: { data_inicial: data_final, data_final: data_inicial }

        expect(response).to redirect_to(volume_vendas_path)
        follow_redirect!
        expect(response.body).to include("Intervalo de datas inválido")
      end

      context "quando requisitado em JSON" do
        it "retorna os dados agregados e o total" do
          create(:danfe,
            user: user,
            valor: 1500,
            data_saida: Date.new(2025, 1, 5),
            remetente: { razao_social: "Loja Centro", cnpj: "12345678000195" }.to_json,
            valores_totais: 1500,
            impostos: { icms: 18.0, ipi: 5.0 }.to_json)

          get volume_vendas_path(format: :json), params: { data_inicial: data_inicial, data_final: data_final }

          expect(response).to have_http_status(:ok)

          payload = JSON.parse(response.body)
          expect(payload).to include("total_geral")
          expect(payload["volume_vendas"]).to be_an(Array)
          expect(payload["volume_vendas"].first).to include("loja" => "Loja Centro")
        end

        it "retorna erro 422 para intervalo inválido" do
          previous_day = Date.parse(data_inicial).prev_day.to_s
          get volume_vendas_path(format: :json), params: { data_inicial: data_final, data_final: previous_day }

          expect(response).to have_http_status(:unprocessable_content)
          payload = JSON.parse(response.body)
          expect(payload["error"]).to eq("Intervalo de datas inválido.")
        end
      end
    end
  end
end
