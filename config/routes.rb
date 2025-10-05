Rails.application.routes.draw do
  resources :users, only: [:new, :create]

  get  'login',  to: 'sessions#new',     as: :new_session
  post 'login',  to: 'sessions#create',  as: :sessions
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  root "sessions#new"
end
