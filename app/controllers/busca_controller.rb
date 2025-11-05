# frozen_string_literal: true

class BuscaController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    @query = params[:query]

    @results = if @query.present?
                 # Buscar no modelo
                 Cliente.search_full_text(@query)
               else
                 []
               end
  end
end
