Rails.application.routes.draw do
  # The second root route takes precedence, so this one can be removed.
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

 # login
  get    'login',  to: 'sessions#new',     as: :new_session
  post   'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  # Rota para busca
  get '/busca', to: 'busca#index'


  # This line was a duplicate and should be removed.
  # get 'exportar', to: 'exportacoes#exportar', as: :exportar_exportacoes

  # Rota para gráficos
  resources :graficos, only: [:index]

  # Rota para visualizar danfes
  resources :danfes, only: [:index]

  # This will be the actual root of your application.
  root "sessions#new"

  get "/debug", to: "uploads#debug"
end
