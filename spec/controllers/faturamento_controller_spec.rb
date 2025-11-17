# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaturamentoController, type: :controller do
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
    context 'quando não existem danfes' do
      before do
        allow(Danfe).to receive(:where).with(user: @user).and_return([])
      end

      it 'define @sem_dados como true' do
        get :index
        expect(assigns(:sem_dados)).to be_truthy
      end
    end

    context 'quando existem danfes' do
      let(:danfes) { double('ActiveRecord::Relation') }

      before do
        allow(Danfe).to receive(:where).with(user: @user).and_return(danfes)
        allow(danfes).to receive_messages(where: danfes, empty?: false)
        allow(danfes).to receive(:sum).with(:valor).and_return(2501.50)
      end

      it 'calcula o faturamento total corretamente' do
        get :index
        expect(assigns(:faturamento_total)).to eq(2501.50)
      end

      it 'exibe por mês por padrão' do
        get :index
        expect(assigns(:visualizacao)).to eq('Por Mês')
      end

      it 'respeita o parâmetro de visualização' do
        get :index, params: { visualizacao: 'Por Cliente' }
        expect(assigns(:visualizacao)).to eq('Por Cliente')
      end
    end

    context 'quando filtrado por período' do
      let(:danfes) { double('ActiveRecord::Relation') }

      before do
        allow(Danfe).to receive(:where).with(user: @user).and_return(danfes)
        allow(Danfe).to receive(:all).and_return(danfes)
        allow(danfes).to receive_messages(where: danfes, empty?: false)
        allow(danfes).to receive(:sum).with(:valor).and_return(1251.00)
      end

      it 'aplica o filtro de período corretamente' do
        expect(danfes).to receive(:where).with(
          'data_saida >= ? AND data_saida <= ?',
          Date.parse('01/01/2025').beginning_of_day,
          Date.parse('28/02/2025').end_of_day
        ).and_return(danfes)

        get :index, params: { data_inicio: '01/01/2025', data_fim: '28/02/2025' }
      end
    end
  end

  describe 'GET #exportar' do
    context 'quando não existem danfes' do
      before do
        allow(Danfe).to receive(:where).with(user: @user).and_return([])
      end

      it 'redireciona para a página de faturamento com mensagem de erro' do
        get :exportar
        expect(response).to redirect_to(faturamento_index_path)
        expect(flash[:alert]).to eq('Não há dados de faturamento disponíveis para exportar')
      end
    end

    context 'quando existem danfes' do
      let(:danfes) { double('ActiveRecord::Relation') }

      before do
        allow(Danfe).to receive(:where).with(user: @user).and_return(danfes)
        allow(danfes).to receive_messages(empty?: false, count: 5)
        allow(danfes).to receive(:each).and_yield(
          double('Danfe',
                 data_saida: Date.new(2025, 2, 15),
                 cliente: 'Cliente A',
                 valor: 123.45,
                 to_s: 'Danfe teste')
        )
        allow(Danfe).to receive(:all).and_return(danfes)
      end

      it 'retorna um arquivo CSV' do
        get :exportar
        expect(response.content_type).to eq('text/csv')
        expect(response.headers['Content-Disposition']).to include('attachment')
        expect(response.headers['Content-Disposition']).to include('faturamento.csv')
      end
    end
  end

  describe 'métodos privados' do
    described_class.new

    describe '#calcular_faturamento_por_mes' do
      let(:danfe1) do
        instance_double(Danfe, valor: 500.75, data_saida: Time.zone.local(2025, 1, 15), cliente: 'Cliente A')
      end
      let(:danfe2) do
        instance_double(Danfe, valor: 750.25, data_saida: Time.zone.local(2025, 1, 20), cliente: 'Cliente B')
      end
      let(:danfe3) do
        instance_double(Danfe, valor: 1250.50, data_saida: Time.zone.local(2025, 2, 5), cliente: 'Cliente C')
      end
      let(:danfes) { [danfe1, danfe2, danfe3] }

      it 'agrupa corretamente o faturamento por mês', skip: 'Implementar quando o método for acessível' do
        # Este teste requer o método ser acessível ou usar send
        # resultado = controller.send(:calcular_faturamento_por_mes, danfes)
        # expect(resultado["Janeiro/2025"]).to eq(1251.0)
        # expect(resultado["Fevereiro/2025"]).to eq(1250.50)
      end
    end
  end
end
