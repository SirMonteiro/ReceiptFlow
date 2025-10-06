Rails.application.routes.draw do
  root "uploads#new"

  resources :uploads, only: [:new, :create]

  resources :exportacoes, only: [:index] do
    collection do
      get :exportar
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [:new, :create]

  get  'login',  to: 'sessions#new',     as: :new_session
  post 'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  get 'exportar', to: 'exportacoes#exportar', as: :exportar_exportacoes

  # Rota para gráficos
  resources :graficos, only: [:index]

  root "sessions#new"

  get "/debug", to: "uploads#debug"
end