# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportacoesController, type: :controller do
  let(:user) { User.create!(nome: 'Teste User', email: 'teste@teste.com', password: '123456') }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #exportar' do
    it 'retorna sucesso e um arquivo de planilha' do
      create(:danfe, user: user)
      get :exportar, params: { format: 'csv' }
      expect(response).to have_http_status(:success)
      expect(response.header['Content-Disposition']).to include('attachment')
    end

    it 'retorna erro para formato não suportado' do
      get :exportar, params: { format: 'xml' }
      expect(response).to have_http_status(:not_acceptable)
    end
  end
end
