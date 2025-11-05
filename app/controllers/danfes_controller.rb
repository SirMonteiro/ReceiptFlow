# frozen_string_literal: true

class DanfesController < ApplicationController
  before_action :require_login, only: [:index]
  def index
    @danfes = current_user.danfes.order(created_at: :desc)
  end

  def filter
    data_inicial = params[:data_inicial].presence
    data_final = params[:data_final].presence

    if data_inicial && data_final
      if datas_validas?(data_inicial, data_final)
        redirect_to result_danfes_path(data_inicial: data_inicial, data_final: data_final)
      else
        flash[:alert] = 'Intervalo de datas inválido. Verifique as datas e tente novamente.'
        redirect_to filter_danfes_path
      end
    else
      render :filter
    end
  end

  def result
    if params[:data_inicial].present? && params[:data_final].present?
      inicio = Date.parse(params[:data_inicial])
      fim = Date.parse(params[:data_final])
      @danfes = Danfe.do_periodo(data_inicial: inicio, data_final: fim)
    else
      @danfes = []
    end
  end

  private

  def datas_validas?(data_inicial, data_final)
    inicio = Date.parse(data_inicial)
    fim = Date.parse(data_final)
    inicio <= fim
  rescue ArgumentError
    false
  end
end
