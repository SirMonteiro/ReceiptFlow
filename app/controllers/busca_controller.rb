class BuscaController < ApplicationController
  before_action :require_login, only: [:index] 

  def index
    @query = params[:query]

    if @query.present?
      # Buscar no modelo
      @results = Cliente.search_full_text(@query)
    else
      @results = []
    end
  end
end
