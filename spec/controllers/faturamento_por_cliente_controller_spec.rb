require 'rails_helper'

RSpec.describe FaturamentoPorClienteController, type: :controller do
  describe "GET #index" do
    it "configura a visualização para 'Por Cliente'" do
      get :index
      expect(assigns(:visualizacao)).to eq("Por Cliente")
    end
    
    it "define o período de 01/01/2025 a 31/03/2025" do
      get :index
      expect(assigns(:data_inicio)).to eq(Date.parse("01/01/2025"))
      expect(assigns(:data_fim)).to eq(Date.parse("31/03/2025"))
    end
    
    it "configura o faturamento por cliente" do
      get :index
      expect(assigns(:faturamento_por_cliente)).to be_a(Hash)
      expect(assigns(:faturamento_por_cliente)["Cliente A"]).to eq(500.75)
      expect(assigns(:faturamento_por_cliente)["Cliente B"]).to eq(750.25)
      expect(assigns(:faturamento_por_cliente)["Cliente C"]).to eq(1250.50)
    end
    
    it "calcula o faturamento total corretamente" do
      get :index
      expect(assigns(:faturamento_total)).to eq(2501.50)
    end
    
    it "renderiza o template de faturamento/index" do
      get :index
      expect(response).to render_template("faturamento/index")
    end
  end
end