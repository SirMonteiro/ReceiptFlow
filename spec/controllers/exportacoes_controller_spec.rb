# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportacoesController, type: :controller do
  describe 'GET #exportar' do
    it 'retorna sucesso e um arquivo de planilha' do
      Pedido.create!(
        cliente: 'Teste',
        valor: 123.45,
        chave_acesso: '12345678901234567890123456789012345678901234',
        natureza_operacao: 'Venda',
        remetente: {
          'razao_social' => 'Empresa X',
          'cnpj' => '12345678000195',
          'endereco' => 'Rua A, 123'
        },
        destinatario: {
          'razao_social' => 'Cliente Y',
          'cnpj' => '98765432000100',
          'endereco' => 'Rua B, 456'
        },
        descricao_produtos: [
          { 'nome' => 'Produto A' },
          { 'nome' => 'Produto B' }
        ],
        valores_totais: 150.75,
        impostos: {
          'icms' => 10.75,
          'ipi' => 5.00
        },
        cfop: '5102',
        cst: '060',
        ncm: '12345678',
        transportadora: {
          'razao_social' => 'Transportadora Z',
          'cnpj' => '11222333000144'
        },
        data_saida: Time.zone.today
      )
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
