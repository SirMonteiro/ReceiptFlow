require "bigdecimal"

class VolumeVendasController < ApplicationController
  before_action :require_login

  def index
    @data_inicial, @data_final = intervalo_de_busca
    @volume_vendas = VolumeVenda.por_periodo(
      data_inicial: @data_inicial,
      data_final: @data_final,
      danfes: danfes_do_usuario
    )
    @total_geral = @volume_vendas.reduce(BigDecimal("0")) do |acumulado, registro|
      acumulado + BigDecimal(registro.valor_total.to_s)
    end
    respond_to do |format|
      format.html
      format.json { render :index, status: :ok }
    end
  rescue ArgumentError
    respond_to do |format|
      format.html { redirect_to volume_vendas_path, alert: "Intervalo de datas inválido. Ajuste as datas e tente novamente." }
      format.json { render json: { error: "Intervalo de datas inválido." }, status: :unprocessable_content }
    end
  end

  private

  def danfes_do_usuario
    current_user.danfes
  end

  def intervalo_de_busca
    if params[:data_inicial].present? && params[:data_final].present?
      inicio = Date.parse(params[:data_inicial])
      fim = Date.parse(params[:data_final])
    else
      hoje = Date.current
      inicio = hoje.beginning_of_month
      fim = hoje.end_of_month
    end

    raise ArgumentError if fim < inicio

    [inicio, fim]
  rescue ArgumentError
    raise ArgumentError
  end
end
