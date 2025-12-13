# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProdutosController, type: :controller do
  let(:user) { User.create!(nome: 'Teste Produtos', email: 'test@produtos.com', password: 'senha123', password_confirmation: 'senha123') }

  def criar_danfe_spec(chave_acesso, descricao, valor, ncm, data_saida, cliente_nome = 'Cliente Teste')
    Danfe.create!(
      user: user,
      chave_acesso: chave_acesso,
      natureza_operacao: 'Venda',
      remetente: 'Empresa A - CNPJ: 12.345.678/0001-95 - Rua A, 100',
      destinatario: "#{cliente_nome} - CNPJ: 98.765.432/0001-95 - Rua B, 200",
      cliente: cliente_nome,
      descricao_produtos: descricao,
      valores_totais: valor,
      valor: valor,
      impostos: { icms: (valor * 0.18).round(2), ipi: (valor * 0.05).round(2) }.to_json,
      cfop: '5102',
      cst: '060',
      ncm: ncm,
      transportadora: 'Trans A - CNPJ: 11.222.333/0001-44',
      data_saida: data_saida
    )
  end

  before do
    session[:user_id] = user.id
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
        criar_danfe_spec('11111111111111111111111111111111111111111111', 'Notebook Dell', 3500.00, '84713012', Date.new(2025, 3, 15), 'Cliente A')
        criar_danfe_spec('22222222222222222222222222222222222222222222', 'Notebook Dell', 3500.00, '84713012', Date.new(2025, 4, 10), 'Cliente B')
        criar_danfe_spec('33333333333333333333333333333333333333333333', 'Mouse Logitech', 450.00, '84716060', Date.new(2025, 3, 20), 'Cliente C')
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
        
        produtos_array = produtos.to_a
        expect(produtos_array.first[0]).to eq('Notebook Dell') # Maior valor
        expect(produtos_array.last[0]).to eq('Mouse Logitech') # Menor valor
      end

      context 'com visualização Por NCM' do
        it 'agrupa produtos por NCM' do
          get :index, params: { visualizacao: 'Por NCM' }
          produtos = assigns(:produtos_estatisticas)
          
          expect(produtos.keys).to include('84713012', '84716060')
          expect(produtos['84713012'][:valor_total]).to eq(7000.00)
          expect(produtos['84716060'][:valor_total]).to eq(450.00)
        end
      end

      context 'com filtro de período' do
        it 'filtra produtos pelo período especificado' do
          get :index, params: { data_inicio: '2025-03-01', data_fim: '2025-03-31' }
          produtos = assigns(:produtos_estatisticas)
          
          # Apenas danfes de março devem ser incluídas
          expect(produtos['Notebook Dell'][:quantidade]).to eq(1) # Apenas uma em março
          expect(produtos['Mouse Logitech'][:quantidade]).to eq(1) # Uma em março
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
        criar_danfe_spec('11111111111111111111111111111111111111111111', 'Notebook Dell', 3500.00, '84713012', Date.new(2025, 3, 15), 'Cliente A')
        criar_danfe_spec('22222222222222222222222222222222222222222222', 'Mouse Logitech', 450.00, '84716060', Date.new(2025, 3, 20), 'Cliente B')
      end

      it 'retorna um arquivo CSV' do
        get :exportar
        
        expect(response.content_type).to eq('text/csv')
        expect(response.headers['Content-Disposition']).to include('produtos.csv')
      end

      it 'inclui cabeçalhos corretos no CSV' do
        get :exportar
        csv_content = response.body
        
        expect(csv_content).to include('Produto')
        expect(csv_content).to include('NCM')
        expect(csv_content).to include('Quantidade')
        expect(csv_content).to include('Valor Total')
        expect(csv_content).to include('Valor Médio')
      end

      it 'inclui dados dos produtos no CSV' do
        get :exportar
        csv_content = response.body
        
        expect(csv_content).to include('Notebook Dell')
        expect(csv_content).to include('84713012')
        expect(csv_content).to include('Mouse Logitech')
        expect(csv_content).to include('84716060')
      end
    end
  end
end
