Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root 'exportacoes#index'

  get 'exportar', to: 'exportacoes#exportar', as: :exportar_exportacoes
end
