# frozen_string_literal: true

class MonthReceiptsController < ApplicationController
  before_action :require_login, only: %i[index show]
  before_action :set_danfe, only: :show

  rescue_from ActiveRecord::RecordNotFound, with: :handle_missing_danfe

  MESES_PT = {
    'January' => 'Janeiro',
    'February' => 'Fevereiro',
    'March' => 'Março',
    'April' => 'Abril',
    'May' => 'Maio',
    'June' => 'Junho',
    'July' => 'Julho',
    'August' => 'Agosto',
    'September' => 'Setembro',
    'October' => 'Outubro',
    'November' => 'Novembro',
    'December' => 'Dezembro'
  }.freeze

  def index
    selected_year = params[:year].presence&.to_i || Time.zone.today.year
    selected_month_num = params[:month].presence&.to_i || Time.zone.today.month
    selected_month_num = Time.zone.today.month unless (1..12).cover?(selected_month_num)

    @selected_month = Date.new(selected_year, selected_month_num, 1)

    @danfes = current_user.danfes
                          .where(data_saida: @selected_month.beginning_of_month..@selected_month.end_of_month)
                          .order(data_saida: :desc)

    @available_months = current_user.danfes
                                    .distinct
                                    .pluck(Arel.sql("DATE_TRUNC('month', data_saida)::date"))
                                    .sort
                                    .reverse

    mes_en = @selected_month.strftime('%B')
    @mes_pt = MESES_PT[mes_en]
    @ano = @selected_month.strftime('%Y')
    @selected_month_num = selected_month_num
  end

  def show; end

  private

  def set_danfe
    @danfe = current_user.danfes.find(params[:id])
  end

  def handle_missing_danfe
    redirect_to month_receipts_path, alert: 'Não encontramos este comprovante.'
  end
end
