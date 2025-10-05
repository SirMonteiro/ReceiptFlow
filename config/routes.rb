Rails.application.routes.draw do
  # 1. Set the home page to your new upload form.
  root "uploads#new"

  # 2. Correctly set up the necessary routes for uploading.
  # This creates a GET route for `uploads/new` and a POST route for `uploads`.
  resources :uploads, only: [:new, :create]

  # 3. Keep the default health check route.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/debug", to: "uploads#debug"
end