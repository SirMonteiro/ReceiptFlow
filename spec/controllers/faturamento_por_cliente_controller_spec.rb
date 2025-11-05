# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaturamentoPorClienteController, type: :controller do
  # precisa de user agora...
  before do
    @user = User.find_or_create_by!(email: 'teste@teste.com') do |user|
      user.nome = 'Usuarilson'
      user.password = '123456'
    end
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(@user)
  end

  describe 'GET #index' do
    it "configura a visualização para 'Por Cliente'" do
      get :index
      expect(assigns(:visualizacao)).to eq('Por Cliente')
    end

    it 'define o período padrão como o mês atual' do
      get :index
      expect(assigns(:data_inicio)).to eq(Time.zone.today.beginning_of_month)
      expect(assigns(:data_fim)).to eq(Time.zone.today.end_of_month)
    end

    it 'configura o faturamento por cliente' do
      # Mock de pedidos para o ambiente de teste
      danfes = double('ActiveRecord::Relation')
      allow(danfes).to receive_messages(empty?: false, where: danfes, sum: 2501.50)
      allow(Danfe).to receive(:where).with(user: @user).and_return(danfes)

      get :index
      expect(assigns(:faturamento_por_cliente)).to be_a(Hash)
      expect(assigns(:faturamento_por_cliente)['Cliente A']).to eq(500.75)
      expect(assigns(:faturamento_por_cliente)['Cliente B']).to eq(750.25)
      expect(assigns(:faturamento_por_cliente)['Cliente C']).to eq(1250.50)
    end

    it 'calcula o faturamento total corretamente' do
      # Mock de pedidos para o ambiente de teste
      danfes = double('ActiveRecord::Relation')
      allow(danfes).to receive_messages(empty?: false, where: danfes, sum: 2501.50)
      allow(Danfe).to receive(:where).with(user: @user).and_return(danfes)

      get :index
      expect(assigns(:faturamento_total)).to eq(2501.50)
    end

    it 'renderiza o template de faturamento/index' do
      get :index
      expect(response).to render_template('faturamento/index')
    end
  end
end
