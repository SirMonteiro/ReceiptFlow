Rails.application.routes.draw do
  root "uploads#new"

  resources :uploads, only: [:new, :create]

  resources :exportacoes, only: [:index] do
    collection do
      get :exportar
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "/debug", to: "uploads#debug"
end