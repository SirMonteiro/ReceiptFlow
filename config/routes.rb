Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  
  # Faz a tela de cadastro ser a página inicial
  root "users#new"
end
