# frozen_string_literal: true

Rails.application.routes.draw do
  resources :volume_vendas, only: [:index]
  # This will be the actual root of your application.
  root 'sessions#new'
  get 'home', to: 'pages#home'
  resources :month_receipts, only: %i[index show]
  # The second root route takes precedence, so this one can be removed.
  # login
  get    'login',  to: 'sessions#new',     as: :new_session
  post   'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  # root "uploads#new"

  resources :uploads, only: %i[new create]

  # 1. GET /products -> products#index
  # 2. POST /products/import -> products#import
  resources :products, only: [:index] do
    collection do
      post :import
    end
  end

  # Routes for NF-e (DANFE) import
  resources :notas_fiscais, only: [:index] do
    collection do
      post :import
    end
  end

  # This block correctly defines the route to /exportacoes/exportar
  resources :exportacoes, only: [:index] do
    collection do
      get :exportar
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :users, only: %i[new create]

  # Rota para busca
  get '/busca', to: 'busca#index'

  # Rota para gráficos
  # This was duplicated, one instance removed
  resources :graficos, only: [:index]

  # Rotas para faturamento
  resources :faturamento, only: [:index] do
    collection do
      get :exportar
      get :filtrar
    end
  end

  # Rota especial para testes de visualização por cliente
  get 'faturamento_por_cliente', to: 'faturamento_por_cliente#index'
  resources :graficos, only: [:index]

  # Rota para visualizar danfes
  resources :danfes, only: [:index]

  # Rotas para Controle Financeiro (metas, orçamento e despesas)
  get 'controle_financeiro', to: 'controle_financeiro#index'

  post 'controle_financeiro/metas', to: 'controle_financeiro#criar_meta'
  patch 'controle_financeiro/metas/:id', to: 'controle_financeiro#atualizar_meta', as: :atualizar_meta
  delete 'controle_financeiro/metas/:id', to: 'controle_financeiro#deletar_meta', as: :deletar_meta

  post 'controle_financeiro/orcamentos', to: 'controle_financeiro#criar_orcamento'
  patch 'controle_financeiro/orcamentos/:id', to: 'controle_financeiro#atualizar_orcamento', as: :atualizar_orcamento
  delete 'controle_financeiro/orcamentos/:id', to: 'controle_financeiro#deletar_orcamento', as: :deletar_orcamento

  post 'controle_financeiro/despesas', to: 'controle_financeiro#criar_despesa'
  delete 'controle_financeiro/despesas/:id', to: 'controle_financeiro#deletar_despesa', as: :deletar_despesa

  # Rotas para faturamento
  resources :faturamento, only: [:index] do
    collection do
      get :exportar
      get :filtrar
    end
  end

  # Rota especial para testes de visualização por cliente
  get 'faturamento_por_cliente', to: 'faturamento_por_cliente#index'

  get 'operacoes', to: 'operacoes#index'

  resources :danfes, only: [:index]
  get    'filtrar',  to: 'danfes#filter', as: :filter_danfes
  get    'resultado',  to: 'danfes#result', as: :result_danfes

  # Rotas para impostos
  resources :impostos, only: [:index] do
    collection do
      get :exportar
    end
  end

  # Rotas para estatísticas de produtos
  resources :produtos, only: [:index] do
    collection do
      get :exportar
    end
  end

  get '/debug', to: 'uploads#debug'
end
