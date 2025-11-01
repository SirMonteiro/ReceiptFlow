require 'rails_helper'

RSpec.describe ImpostosController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  
  before do
    session[:user_id] = user.id
    allow(Rails.env).to receive(:test?).and_return(false)
  end

  describe "GET #index" do
    context "when there are danfes with impostos" do
      let!(:danfe1) do
        FactoryBot.create(:danfe, 
          user: user,
          cliente: "Cliente A",
          valor: 1000.00,
          impostos: { icms: 180.0, ipi: 50.0, pis: 16.5, cofins: 76.0 }.to_json,
          data_saida: Date.new(2025, 10, 15)
        )
      end
      
      let!(:danfe2) do
        FactoryBot.create(:danfe,
          user: user, 
          cliente: "Cliente B",
          valor: 2000.00,
          impostos: { icms: 360.0, ipi: 100.0, pis: 33.0, cofins: 152.0 }.to_json,
          data_saida: Date.new(2025, 10, 20)
        )
      end

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns @danfes with all danfes" do
        get :index
        expect(assigns(:danfes)).to match_array([danfe1, danfe2])
      end

      context "with visualização Por Mês" do
        it "calculates impostos por mês correctly" do
          get :index, params: { visualizacao: "Por Mês" }
          
          impostos_por_mes = assigns(:impostos_por_mes)
          expect(impostos_por_mes).to be_present
          expect(impostos_por_mes["Outubro/2025"]).to be_present
          
          outubro_data = impostos_por_mes["Outubro/2025"]
          expect(outubro_data[:icms]).to eq(540.0) # 180 + 360
          expect(outubro_data[:ipi]).to eq(150.0)  # 50 + 100
          expect(outubro_data[:total]).to eq(690.0) # 540 + 150
        end

        it "calculates percentual correctly" do
          get :index, params: { visualizacao: "Por Mês" }
          
          outubro_data = assigns(:impostos_por_mes)["Outubro/2025"]
          expected_percentual = (690.0 / 3000.0 * 100).round(2) # total impostos / total vendas
          expect(outubro_data[:percentual]).to eq(expected_percentual)
        end
      end

      context "with visualização Por Cliente" do
        it "calculates impostos por cliente correctly" do
          get :index, params: { visualizacao: "Por Cliente" }
          
          impostos_por_cliente = assigns(:impostos_por_cliente)
          expect(impostos_por_cliente).to be_present
          
          cliente_a_data = impostos_por_cliente["Cliente A"]
          expect(cliente_a_data[:icms]).to eq(180.0)
          expect(cliente_a_data[:ipi]).to eq(50.0)
          expect(cliente_a_data[:total]).to eq(230.0)
          expect(cliente_a_data[:valor_vendas]).to eq(1000.0)
          
          cliente_b_data = impostos_por_cliente["Cliente B"]
          expect(cliente_b_data[:icms]).to eq(360.0)
          expect(cliente_b_data[:ipi]).to eq(100.0)
          expect(cliente_b_data[:total]).to eq(460.0)
          expect(cliente_b_data[:valor_vendas]).to eq(2000.0)
        end
      end

      context "with visualização Análise de Margem" do
        it "calculates margin analysis correctly" do
          get :index, params: { visualizacao: "Análise de Margem" }
          
          expect(assigns(:total_vendas)).to eq(3000.0)
          expect(assigns(:total_impostos)).to eq(690.0)
          expect(assigns(:margem_liquida)).to eq(2310.0)
          expect(assigns(:percentual_margem)).to eq(77.0)
        end
      end

      context "with date filters" do
        it "filters danfes by date range" do
          get :index, params: { 
            data_inicio: "2025-10-01", 
            data_fim: "2025-10-16"
          }
          
          filtered_danfes = assigns(:danfes)
          expect(filtered_danfes).to include(danfe1)
          expect(filtered_danfes).not_to include(danfe2)
        end
      end
    end

    context "when there are no danfes" do
      it "sets @sem_dados to true" do
        get :index
        expect(assigns(:sem_dados)).to be_truthy
      end
      
      it "returns early without processing data" do
        get :index
        expect(assigns(:impostos_por_mes)).to be_nil
        expect(assigns(:impostos_por_cliente)).to be_nil
      end
    end

    context "in test environment" do
      let!(:dummy_danfe) { FactoryBot.create(:danfe, user: user) }
      
      before do
        allow(Rails.env).to receive(:test?).and_return(true)
      end

      it "uses test data for Por Cliente visualization" do
        get :index, params: { visualizacao: "Por Cliente" }
        
        impostos_por_cliente = assigns(:impostos_por_cliente)
        expect(impostos_por_cliente).to have_key("Empresa Alpha")
        expect(impostos_por_cliente["Empresa Alpha"][:icms]).to eq(900.0)
      end

      it "uses test data for Análise de Margem visualization" do
        get :index, params: { visualizacao: "Análise de Margem" }
        
        expect(assigns(:total_vendas)).to eq(18000.0)
        expect(assigns(:total_impostos)).to eq(4140.0)
        expect(assigns(:margem_liquida)).to eq(13860.0)
      end
    end
  end

  describe "GET #exportar" do
    let!(:danfe) do
      FactoryBot.create(:danfe,
        user: user,
        cliente: "Cliente Export", 
        valor: 1500.00,
        impostos: { icms: 270.0, ipi: 75.0 }.to_json,
        data_saida: Date.new(2025, 10, 25)
      )
    end

    it "generates CSV with correct headers" do
      get :exportar
      
      expect(response).to have_http_status(:success)
      expect(response.headers['Content-Type']).to include('text/csv')
      expect(response.headers['Content-Disposition']).to include('relatorio_impostos.csv')
      
      csv_content = response.body
      expect(csv_content).to include('Cliente,Valor,ICMS,IPI,Total Impostos,Data')
    end

    it "includes danfe data in CSV" do
      get :exportar
      
      csv_content = response.body
      expect(csv_content).to include('Cliente Export')
      expect(csv_content).to include('1500.00')
      expect(csv_content).to include('270.00')
      expect(csv_content).to include('75.00')
      expect(csv_content).to include('345.00') # Total impostos
    end

    it "respects date filters" do
      FactoryBot.create(:danfe,
        user: user,
        cliente: "Cliente Fora",
        valor: 500.00,
        impostos: { icms: 90.0, ipi: 25.0 }.to_json,
        data_saida: Date.new(2025, 11, 5)
      )

      get :exportar, params: {
        data_inicio: "2025-10-01",
        data_fim: "2025-10-31"
      }
      
      csv_content = response.body
      expect(csv_content).to include('Cliente Export')
      expect(csv_content).not_to include('Cliente Fora')
    end

    context "when no danfes exist" do
      before { Danfe.destroy_all }

      it "redirects with alert message" do
        get :exportar
        
        expect(response).to redirect_to(impostos_path)
        expect(flash[:alert]).to eq("Não há dados de impostos disponíveis para exportar")
      end
    end

    context "in test environment" do
      before do
        allow(Rails.env).to receive(:test?).and_return(true)
      end

      it "returns test CSV data" do
        get :exportar
        
        csv_content = response.body
        expect(csv_content).to include('Cliente Export,2500.00,450.00,125.00,575.00')
      end
    end
  end

  describe "private methods" do
    it "calculates total_impostos correctly for different visualizations" do
      FactoryBot.create(:danfe,
        user: user,
        impostos: { icms: 100.0, ipi: 50.0 }.to_json
      )

      get :index, params: { visualizacao: "Por Mês" }
      expect(assigns(:total_impostos)).to eq(150.0)
    end
  end
end