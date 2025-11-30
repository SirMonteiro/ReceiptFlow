# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'month_receipts/show', type: :view do
  let(:user) { create(:user) }
  let(:danfe) do
    create(:danfe,
           user: user,
           data_saida: Date.new(2025, 10, 20),
           valor: 1234.56,
           chave_acesso: '12345678901234567890123456789012345678901234',
           remetente: { 'razao_social' => 'Empresa Remetente', 'cnpj' => '11.222.333/0001-44',
                        'endereco' => 'Rua A, 123' }.to_json,
           destinatario: { 'razao_social' => 'Empresa Destinatária', 'cnpj' => '55.666.777/0001-88',
                           'endereco' => 'Rua B, 456' }.to_json,
           impostos: { 'icms' => 100.0, 'ipi' => 50.0 }.to_json,
           descricao_produtos: 'Produto 1; Produto 2')
  end

  before do
    assign(:danfe, danfe)
  end

  it 'renders the DANFE details' do
    render

    expect(rendered).to include('Detalhes do Comprovante')
    expect(rendered).to include('Empresa Remetente')
    expect(rendered).to include('Empresa Destinatária')
    expect(rendered).to include('Produto 1')
    expect(rendered).to include('R$ 1.234,56')
  end
end
