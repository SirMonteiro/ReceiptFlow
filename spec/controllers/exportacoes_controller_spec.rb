require 'rails_helper'

RSpec.describe ExportacoesController, type: :controller do
  describe 'GET #exportar' do
    it 'retorna sucesso e um arquivo de planilha' do
      pedido = Pedido.create!(cliente: 'Teste', valor: 123.45)
      get :exportar, params: { format: 'csv' }
      expect(response).to have_http_status(:success)
      expect(response.header['Content-Disposition']).to include('attachment')
    end

    it 'retorna erro para formato não suportado' do
      get :exportar, params: { format: 'xml' }
      expect(response).to have_http_status(406)
    end
  end
end
