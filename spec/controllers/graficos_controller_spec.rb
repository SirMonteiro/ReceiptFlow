require 'rails_helper'

RSpec.describe GraficosController, type: :controller do
  describe 'GET #index' do
    before do
      @user = User.create!(
        email: 'teste@teste.com',
        nome: 'Usuário Teste',
        password: '123456'
      )

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(@user)
    end

    context 'com dados de vendas, despesas e metas' do
      before do
        (0..6).each do |i|
          Danfe.create!(
            user: @user,
            number: i,
            cliente: 'Dr.Strangelove',
            valor: 100 * (i + 1),
            chave_acesso: "CHAVE#{i}",
            natureza_operacao: 'venda',
            remetente: 'Stanley Kubrick',
            destinatario: 'Destinatarilson',
            descricao_produtos: 'doomsday machine ahh produtos',
            valores_totais: 100 * (i + 1),
            impostos: 0,
            cfop: '5102',
            cst: '00',
            ncm: '12345678',
            transportadora: 'Transportadora',
            data_saida: i.months.ago.beginning_of_month
          )
        end

        (0..6).each do |i|
          Despesa.create!(
            user: @user,
            valor: 50 * (i + 1),
            data: i.months.ago.beginning_of_month
          )
        end

        (0..6).each do |i|
          MetaMensal.create!(
            user: @user,
            valor_meta: 10 * (i + 1),
            mes: (11 - i),
            ano: 2025
          )
        end

        (0..6).each do |i|
          OrcamentoMensal.create!(
            user: @user,
            valor: 200 * (i + 1),
            mes: (11 - i),
            ano: 2025
          )
        end

        get :index
      end

      it 'pega somente as danfes dos últimos 6 meses' do
        expect(assigns(:vendas).length).to eq(6)
      end

      it 'soma corretamente os valores das vendas' do
        totais = assigns(:vendas).map { |v| v.total.to_f }.sort
        expect(totais).to eq([100, 200, 300, 400, 500, 600])
      end

      it 'pega somente as despesas dos últimos 6 meses' do
        expect(assigns(:despesas).length).to eq(6)
      end

      it 'soma corretamente os valores das despesas' do
        totais = assigns(:despesas).map { |d| d.total.to_f }.sort
        expect(totais).to eq([50, 100, 150, 200, 250, 300])
      end

      it 'pega somente as 6 metas mais recentes' do
        expect(assigns(:metas).length).to eq(6)
      end

      it 'pega somente os 6 orçamentos mais recentes' do
        expect(assigns(:orcamentos).length).to eq(6)
      end
    end
  end
end
