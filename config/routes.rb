Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [:new, :create]

  get  'login',  to: 'sessions#new',     as: :new_session
  post 'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  get 'exportar', to: 'exportacoes#exportar', as: :exportar_exportacoes

  # Rota para gráficos
  resources :graficos, only: [:index]

  root "sessions#new"

  # Defines the root path route ("/")
  # root "posts#index"
end
