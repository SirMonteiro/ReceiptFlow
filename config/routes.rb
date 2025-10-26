Rails.application.routes.draw do
  resources :month_receipts
  # root "uploads#new" # As noted, this is commented out

  resources :uploads, only: [:new, :create]

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

  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [:new, :create]

  # login
  get    'login',  to: 'sessions#new',     as: :new_session
  post   'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

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

  # Rota para visualizar danfes
  resources :danfes, only: [:index]

  # This will be the actual root of your application.
  root "sessions#new"

  get "/debug", to: "uploads#debug"
end

