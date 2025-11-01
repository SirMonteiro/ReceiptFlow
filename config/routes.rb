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

  resources :danfes, only: [:index, :filter, :result]
  get    'filtrar',  to: 'danfes#filter',     as: :filter_danfes
  get    'resultado',  to: 'danfes#result',  as: :result_danfes

  # Rotas para impostos
  resources :impostos, only: [:index] do
    collection do
      get :exportar
    end
  end
  get "/debug", to: "uploads#debug"
end

