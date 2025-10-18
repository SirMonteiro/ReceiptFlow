require 'rails_helper'

RSpec.describe FaturamentoPorClienteController, type: :controller do
  describe "GET #index" do
    it "configura a visualização para 'Por Cliente'" do
      get :index
      expect(assigns(:visualizacao)).to eq("Por Cliente")
    end
    
    it "define o período padrão como o mês atual" do
      get :index
      expect(assigns(:data_inicio)).to eq(Date.today.beginning_of_month)
      expect(assigns(:data_fim)).to eq(Date.today.end_of_month)
    end
    
    it "configura o faturamento por cliente" do
      # Mock de pedidos para o ambiente de teste
      pedidos = double("ActiveRecord::Relation")
      allow(pedidos).to receive(:empty?).and_return(false)
      allow(pedidos).to receive(:where).and_return(pedidos)
      allow(pedidos).to receive(:sum).and_return(2501.50)
      allow(Pedido).to receive(:all).and_return(pedidos)
      
      get :index
      expect(assigns(:faturamento_por_cliente)).to be_a(Hash)
      expect(assigns(:faturamento_por_cliente)["Cliente A"]).to eq(500.75)
      expect(assigns(:faturamento_por_cliente)["Cliente B"]).to eq(750.25)
      expect(assigns(:faturamento_por_cliente)["Cliente C"]).to eq(1250.50)
    end
    
    it "calcula o faturamento total corretamente" do
      # Mock de pedidos para o ambiente de teste
      pedidos = double("ActiveRecord::Relation")
      allow(pedidos).to receive(:empty?).and_return(false)
      allow(pedidos).to receive(:where).and_return(pedidos)
      allow(pedidos).to receive(:sum).and_return(2501.50)
      allow(Pedido).to receive(:all).and_return(pedidos)
      
      get :index
      expect(assigns(:faturamento_total)).to eq(2501.50)
    end
    
    it "renderiza o template de faturamento/index" do
      get :index
      expect(response).to render_template("faturamento/index")
    end
  end
end