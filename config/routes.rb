Rails.application.routes.draw do
  # 1. Set the home page to your upload form.
  root "uploads#new"

  # 2. Set up the necessary routes for uploading.
  resources :uploads, only: [:new, :create]

  # 3. ADDED - Routes for the export feature.
  # This creates a page at /exportacoes and an action at /exportacoes/exportar
  resources :exportacoes, only: [:index] do
    collection do
      get :exportar
    end
  end

  # 4. Keep the default health check route.
  get "up" => "rails/health#show", as: :rails_health_check

  # 5. Keep your debug route.
  get "/debug", to: "uploads#debug"
end