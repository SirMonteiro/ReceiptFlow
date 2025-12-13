# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProdutosController, type: :controller do
  let(:user) { User.create!(email: 'test@produtos.com', password: 'senha123', password_confirmation: 'senha123') }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'quando não existem danfes' do
      it 'define @sem_dados como true' do
        get :index
        expect(assigns(:sem_dados)).to be true
      end
    end

    context 'quando existem danfes com produtos' do
      before do
        Danfe.create!(
          user: user,
          chave_acesso: '11111111111111111111111111111111111111111111',
          natureza_operacao: 'Venda',
          remetente_razao_social: 'Empresa A',
          remetente_cnpj: '12345678000195',
          remetente_endereco: 'Rua A, 100',
          destinatario_razao_social: 'Cliente A',
          destinatario_cnpj: '98765432000195',
          destinatario_endereco: 'Rua B, 200',
          descricao_produtos: 'Notebook Dell',
          valores_totais: 3500.00,
          icms: 630.00,
          ipi: 175.00,
          cfop: '5102',
          cst: '060',
          ncm: '84713012',
          transportadora_razao_social: 'Trans A',
          transportadora_cnpj: '11222333000144',
          data_saida: Date.new(2025, 3, 15)
        )

        Danfe.create!(
          user: user,
          chave_acesso: '22222222222222222222222222222222222222222222',
          natureza_operacao: 'Venda',
          remetente_razao_social: 'Empresa A',
          remetente_cnpj: '12345678000195',
          remetente_endereco: 'Rua A, 100',
          destinatario_razao_social: 'Cliente B',
          destinatario_cnpj: '98765432000196',
          destinatario_endereco: 'Rua C, 300',
          descricao_produtos: 'Notebook Dell',
          valores_totais: 3500.00,
          icms: 630.00,
          ipi: 175.00,
          cfop: '5102',
          cst: '060',
          ncm: '84713012',
          transportadora_razao_social: 'Trans A',
          transportadora_cnpj: '11222333000144',
          data_saida: Date.new(2025, 4, 10)
        )

        Danfe.create!(
          user: user,
          chave_acesso: '33333333333333333333333333333333333333333333',
          natureza_operacao: 'Venda',
          remetente_razao_social: 'Empresa A',
          remetente_cnpj: '12345678000195',
          remetente_endereco: 'Rua A, 100',
          destinatario_razao_social: 'Cliente C',
          destinatario_cnpj: '98765432000197',
          destinatario_endereco: 'Rua D, 400',
          descricao_produtos: 'Mouse Logitech',
          valores_totais: 450.00,
          icms: 81.00,
          ipi: 22.50,
          cfop: '5102',
          cst: '060',
          ncm: '84716060',
          transportadora_razao_social: 'Trans A',
          transportadora_cnpj: '11222333000144',
          data_saida: Date.new(2025, 3, 20)
        )
      end

      it 'agrupa produtos por descrição por padrão' do
        get :index
        produtos = assigns(:produtos_estatisticas)
        
        expect(produtos).to be_a(Hash)
        expect(produtos.keys).to include('Notebook Dell', 'Mouse Logitech')
      end

      it 'calcula valor total corretamente por produto' do
        get :index
        produtos = assigns(:produtos_estatisticas)
        
        expect(produtos['Notebook Dell'][:valor_total]).to eq(7000.00)
        expect(produtos['Mouse Logitech'][:valor_total]).to eq(450.00)
      end

      it 'calcula quantidade de vendas corretamente' do
        get :index
        produtos = assigns(:produtos_estatisticas)
        
        expect(produtos['Notebook Dell'][:quantidade]).to eq(2)
        expect(produtos['Mouse Logitech'][:quantidade]).to eq(1)
      end

      it 'ordena produtos por valor total decrescente' do
        get :index
        produtos = assigns(:produtos_estatisticas)
        valores = produtos.values.map { |p| p[:valor_total] }
        
        expect(valores).to eq(valores.sort.reverse)
      end

      context 'com visualização Por NCM' do
        it 'agrupa produtos por NCM' do
          get :index, params: { visualizacao: 'Por NCM' }
          produtos = assigns(:produtos_estatisticas)
          
          expect(produtos.keys).to include('84713012', '84716060')
          expect(produtos['84713012'][:valor_total]).to eq(7000.00)
        end
      end

      context 'com filtro de período' do
        it 'filtra produtos pelo período especificado' do
          get :index, params: { 
            data_inicio: '2025-03-01', 
            data_fim: '2025-03-31' 
          }
          produtos = assigns(:produtos_estatisticas)
          
          expect(produtos.keys).to include('Notebook Dell', 'Mouse Logitech')
          expect(produtos['Notebook Dell'][:quantidade]).to eq(1) # Apenas março
        end
      end
    end
  end

  describe 'GET #exportar' do
    context 'quando não existem danfes' do
      it 'redireciona para a página de produtos com mensagem de erro' do
        get :exportar
        expect(response).to redirect_to(produtos_path)
        expect(flash[:alert]).to eq('Não há dados para exportar')
      end
    end

    context 'quando existem danfes' do
      before do
        Danfe.create!(
          user: user,
          chave_acesso: '11111111111111111111111111111111111111111111',
          natureza_operacao: 'Venda',
          remetente_razao_social: 'Empresa A',
          remetente_cnpj: '12345678000195',
          remetente_endereco: 'Rua A, 100',
          destinatario_razao_social: 'Cliente A',
          destinatario_cnpj: '98765432000195',
          destinatario_endereco: 'Rua B, 200',
          descricao_produtos: 'Notebook Dell',
          valores_totais: 3500.00,
          icms: 630.00,
          ipi: 175.00,
          cfop: '5102',
          cst: '060',
          ncm: '84713012',
          transportadora_razao_social: 'Trans A',
          transportadora_cnpj: '11222333000144',
          data_saida: Date.new(2025, 3, 15)
        )
      end

      it 'retorna um arquivo CSV' do
        get :exportar
        expect(response.content_type).to include('text/csv')
        expect(response.headers['Content-Disposition']).to include('produtos.csv')
      end

      it 'inclui cabeçalhos corretos no CSV' do
        get :exportar
        csv_content = response.body
        
        expect(csv_content).to include('Produto')
        expect(csv_content).to include('NCM')
        expect(csv_content).to include('Valor Total')
        expect(csv_content).to include('Quantidade')
      end

      it 'inclui dados dos produtos no CSV' do
        get :exportar
        csv_content = response.body
        
        expect(csv_content).to include('Notebook Dell')
        expect(csv_content).to include('84713012')
        expect(csv_content).to include('3500.0')
      end
    end
  end
end
