Rails.application.routes.draw do
  # This will be the actual root of your application.
  root "sessions#new"
  get 'home', to: 'pages#home'
  resources :month_receipts
  # The second root route takes precedence, so this one can be removed.
  # login
  get    'login',  to: 'sessions#new',     as: :new_session
  post   'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session
  
  # root "uploads#new"

  resources :uploads, only: [:new, :create]

  # This block correctly defines the route to /exportacoes/exportar
  # with the name exportar_exportacoes.
  resources :exportacoes, only: [:index] do
    collection do
      get :exportar
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [:new, :create]


  # Rota para busca
  get '/busca', to: 'busca#index'


  # This line was a duplicate and should be removed.
  # get 'exportar', to: 'exportacoes#exportar', as: :exportar_exportacoes

  # Rota para gráficos
  resources :graficos, only: [:index]
  
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
  resources :graficos, only: [:index]

  # Rota para visualizar danfes
  resources :danfes, only: [:index]


  get "/debug", to: "uploads#debug"
end
