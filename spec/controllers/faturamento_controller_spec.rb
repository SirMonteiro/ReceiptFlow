require 'rails_helper'

RSpec.describe FaturamentoController, type: :controller do
  describe "GET #index" do
    context "quando não existem pedidos" do
      before do
        allow(Pedido).to receive(:all).and_return([])
      end

      it "define @sem_dados como true" do
        get :index
        expect(assigns(:sem_dados)).to be_truthy
      end
    end

    context "quando existem pedidos" do
      let(:pedidos) { double("ActiveRecord::Relation") }
      
      before do
        allow(Pedido).to receive(:all).and_return(pedidos)
        allow(pedidos).to receive(:where).and_return(pedidos)
        allow(pedidos).to receive(:empty?).and_return(false)
        allow(pedidos).to receive(:sum).with(:valor).and_return(2501.50)
      end

      it "calcula o faturamento total corretamente" do
        get :index
        expect(assigns(:faturamento_total)).to eq(2501.50)
      end

      it "exibe por mês por padrão" do
        get :index
        expect(assigns(:visualizacao)).to eq("Por Mês")
      end

      it "respeita o parâmetro de visualização" do
        get :index, params: { visualizacao: "Por Cliente" }
        expect(assigns(:visualizacao)).to eq("Por Cliente")
      end
    end
    
    context "quando filtrado por período" do
      let(:pedidos) { double("ActiveRecord::Relation") }
      
      before do
        allow(Pedido).to receive(:all).and_return(pedidos)
        allow(pedidos).to receive(:empty?).and_return(false)
        allow(pedidos).to receive(:sum).with(:valor).and_return(1251.00)
      end

      it "aplica o filtro de período corretamente" do
        expect(pedidos).to receive(:where).with(
          "data_saida >= ? AND data_saida <= ?", 
          Date.parse("01/01/2025").beginning_of_day, 
          Date.parse("28/02/2025").end_of_day
        ).and_return(pedidos)
          
        get :index, params: { data_inicio: "01/01/2025", data_fim: "28/02/2025" }
      end
    end
  end

  describe "GET #exportar" do
    context "quando não existem pedidos" do
      before do
        allow(Pedido).to receive(:all).and_return([])
      end

      it "redireciona para a página de faturamento com mensagem de erro" do
        get :exportar
        expect(response).to redirect_to(faturamento_index_path)
        expect(flash[:alert]).to eq("Não há dados de faturamento disponíveis para exportar")
      end
    end

    context "quando existem pedidos" do
      let(:pedidos) { double("ActiveRecord::Relation") }
      
      before do
        allow(pedidos).to receive(:empty?).and_return(false)
        allow(Pedido).to receive(:all).and_return(pedidos)
      end

      it "retorna um arquivo CSV" do
        get :exportar
        expect(response.content_type).to eq("text/csv")
        expect(response.headers["Content-Disposition"]).to include("attachment")
        expect(response.headers["Content-Disposition"]).to include("faturamento.csv")
      end
    end
  end

  # Testes para métodos privados
  describe "métodos privados" do
    controller = FaturamentoController.new
    
    describe "#calcular_faturamento_por_mes" do
      let(:pedido1) { instance_double(Pedido, valor: 500.75, data_saida: Time.new(2025, 1, 15), cliente: "Cliente A") }
      let(:pedido2) { instance_double(Pedido, valor: 750.25, data_saida: Time.new(2025, 1, 20), cliente: "Cliente B") }
      let(:pedido3) { instance_double(Pedido, valor: 1250.50, data_saida: Time.new(2025, 2, 5), cliente: "Cliente C") }
      let(:pedidos) { [pedido1, pedido2, pedido3] }

      it "agrupa corretamente o faturamento por mês", skip: "Implementar quando o método for acessível" do
        # Este teste requer o método ser acessível ou usar send
        # resultado = controller.send(:calcular_faturamento_por_mes, pedidos)
        # expect(resultado["Janeiro/2025"]).to eq(1251.0)
        # expect(resultado["Fevereiro/2025"]).to eq(1250.50)
      end
    end
  end
end