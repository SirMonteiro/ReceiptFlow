require 'rails_helper'

RSpec.describe ControleFinanceiroController, type: :controller do

   # precisa de user agora...
  before do
    @user = User.find_or_create_by!(email: "teste@teste.com") do |user| 
      user.nome = "Usuarilson" 
      user.password = "123456" 
    end
  allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(@user)
  end

  describe "GET #index" do
    it "atribui corretamente as variáveis de instância" do
      meta = double("MetaMensal")
      orcamento = double("OrcamentoMensal")
      despesa = double("Despesa")

      metas_mensais = double("ActiveRecord::Relation")
      orcamentos_mensais = double("ActiveRecord::Relation")
      despesas = double("ActiveRecord::Relation")

      allow(@user).to receive(:metas_mensais).and_return(metas_mensais)
      allow(@user).to receive(:orcamentos_mensais).and_return(orcamentos_mensais)
      allow(@user).to receive(:despesas).and_return(despesas)

      allow(metas_mensais).to receive(:find_by).and_return(meta)
      allow(orcamentos_mensais).to receive(:find_by).and_return(orcamento)
      allow(metas_mensais).to receive_message_chain(:where, :not).and_return([])
      allow(orcamentos_mensais).to receive_message_chain(:where, :not).and_return([])
      allow(despesas).to receive(:order).and_return([despesa])

      get :index

      expect(assigns(:meta_atual)).to eq(meta)
      expect(assigns(:orcamento_atual)).to eq(orcamento)
      expect(assigns(:despesas)).to include(despesa)
      expect(assigns(:nova_meta)).to be_a(MetaMensal)
      expect(assigns(:novo_orcamento)).to be_a(OrcamentoMensal)
      expect(assigns(:nova_despesa)).to be_a(Despesa)
      expect(response).to have_http_status(:ok)
    end
  end

  # Testes de meta...
  describe "POST #criar_meta" do
    it "cria uma nova meta e redireciona com sucesso" do
      meta = double("MetaMensal", save: true)
      metas = double("Relation")

      allow(@user).to receive(:metas_mensais).and_return(metas)
      allow(metas).to receive(:new).and_return(meta)

      post :criar_meta, params: { meta_mensal: { mes: 1, ano: 2025, valor_meta: 500 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Meta criada com sucesso!")
    end

    it "falha ao criar meta e mostra alerta" do
      meta = double("MetaMensal", save: false)
      metas = double("Relation")

      allow(@user).to receive(:metas_mensais).and_return(metas)
      allow(metas).to receive(:new).and_return(meta)

      post :criar_meta, params: { meta_mensal: { mes: nil, ano: 2025, valor_meta: 500 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:alert]).to eq("Erro ao criar meta.")
    end
  end

  describe "PATCH #atualizar_meta" do
    it "atualiza meta existente com sucesso" do
      meta = double("MetaMensal", update: true)
      metas = double("Relation")

      allow(@user).to receive(:metas_mensais).and_return(metas)
      allow(metas).to receive(:find).with("1").and_return(meta)

      patch :atualizar_meta, params: { id: "1", meta_mensal: { valor_meta: 2000 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Meta atualizada!")
    end
  end

  describe "DELETE #deletar_meta" do
    it "exclui meta e redireciona" do
      meta = double("MetaMensal")
      metas = double("Relation")

      allow(@user).to receive(:metas_mensais).and_return(metas)
      allow(metas).to receive(:find).with("1").and_return(meta)
      allow(meta).to receive(:destroy)

      delete :deletar_meta, params: { id: "1" }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Meta excluída!")
    end
  end

  # Testes de orçamento...
  describe "POST #criar_orcamento" do
    it "cria um novo orçamento e redireciona" do
      orcamento = double("OrcamentoMensal", save: true)
      orcamentos = double("Relation")

      allow(@user).to receive(:orcamentos_mensais).and_return(orcamentos)
      allow(orcamentos).to receive(:new).and_return(orcamento)

      post :criar_orcamento, params: { orcamento_mensal: { mes: 1, ano: 2025, valor: 1500 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Orçamento criado!")
    end

    it "falha ao criar orçamento" do
      orcamento = double("OrcamentoMensal", save: false)
      orcamentos = double("Relation")

      allow(@user).to receive(:orcamentos_mensais).and_return(orcamentos)
      allow(orcamentos).to receive(:new).and_return(orcamento)

      post :criar_orcamento, params: { orcamento_mensal: { mes: nil, ano: 2025, valor: 1500 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:alert]).to eq("Erro ao criar orçamento.")
    end
  end

  describe "PATCH #atualizar_orcamento" do
    it "atualiza orçamento existente" do
      orcamento = double("OrcamentoMensal", update: true)
      orcamentos = double("Relation")

      allow(@user).to receive(:orcamentos_mensais).and_return(orcamentos)
      allow(orcamentos).to receive(:find).with("1").and_return(orcamento)

      patch :atualizar_orcamento, params: { id: "1", orcamento_mensal: { valor: 2000 } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Orçamento atualizado!")
    end
  end

  describe "DELETE #deletar_orcamento" do
    it "exclui orçamento e redireciona" do
      orcamento = double("OrcamentoMensal")
      orcamentos = double("Relation")

      allow(@user).to receive(:orcamentos_mensais).and_return(orcamentos)
      allow(orcamentos).to receive(:find).with("1").and_return(orcamento)
      allow(orcamento).to receive(:destroy)

      delete :deletar_orcamento, params: { id: "1" }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Orçamento excluído!")
    end
  end

  # Testes de despesas...
  describe "POST #criar_despesa" do
    it "cria uma nova despesa e redireciona" do
      despesa = double("Despesa", save: true)
      despesas = double("Relation")

      allow(@user).to receive(:despesas).and_return(despesas)
      allow(despesas).to receive(:new).and_return(despesa)

      post :criar_despesa, params: { despesa: { valor: 250, data: Date.today, descricao: "holocausto nuclear" } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Despesa adicionada!")
    end

    it "falha ao criar despesa e mostra alerta" do
      despesa = double("Despesa", save: false)
      despesas = double("Relation")

      allow(@user).to receive(:despesas).and_return(despesas)
      allow(despesas).to receive(:new).and_return(despesa)

      post :criar_despesa, params: { despesa: { valor: nil, data: Date.today, descricao: "holocausto nuclear" } }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:alert]).to eq("Erro ao adicionar despesa.")
    end
  end

  describe "DELETE #deletar_despesa" do
    it "exclui despesa e redireciona" do
      despesa = double("Despesa")
      despesas = double("Relation")

      allow(@user).to receive(:despesas).and_return(despesas)
      allow(despesas).to receive(:find).with("1").and_return(despesa)
      allow(despesa).to receive(:destroy)

      delete :deletar_despesa, params: { id: "1" }

      expect(response).to redirect_to(controle_financeiro_path)
      expect(flash[:notice]).to eq("Despesa excluída!")
    end
  end

end