class MonthReceiptsController < ApplicationController
  before_action :require_login, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :set_month_receipt, only: %i[ show edit update destroy ]

  MESES_PT = {
    "January" => "Janeiro",
    "February" => "Fevereiro",
    "March" => "Março",
    "April" => "Abril",
    "May" => "Maio",
    "June" => "Junho",
    "July" => "Julho",
    "August" => "Agosto",
    "September" => "Setembro",
    "October" => "Outubro",
    "November" => "Novembro",
    "December" => "Dezembro"
  }

  # GET /month_receipts or /month_receipts.json
  def index
    # Get selected month and year from params or use current date
    selected_year = params[:year].present? ? params[:year].to_i : Date.today.year
    selected_month_num = params[:month].present? ? params[:month].to_i : Date.today.month

    @selected_month = Date.new(selected_year, selected_month_num, 1)

    @danfes = Danfe.where(
      data_saida: @selected_month.beginning_of_month..@selected_month.end_of_month
    ).order(data_saida: :desc)

    @available_months = Danfe.pluck(Arel.sql("DATE_TRUNC('month', data_saida)::date"))
                              .uniq
                              .sort
                              .reverse

    # Format selected month in Portuguese
    mes_en = @selected_month.strftime("%B")
    @mes_pt = MESES_PT[mes_en]
    @ano = @selected_month.strftime("%Y")
    @selected_month_num = selected_month_num
  end

  # GET /month_receipts/1 or /month_receipts/1.json
  def show
  end

  # GET /month_receipts/new
  def new
    @month_receipt = MonthReceipt.new
  end

  # GET /month_receipts/1/edit
  def edit
  end

  # POST /month_receipts or /month_receipts.json
  def create
  end

  # PATCH/PUT /month_receipts/1 or /month_receipts/1.json
  def update
  end

  # DELETE /month_receipts/1 or /month_receipts/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_month_receipt
      @month_receipt = MonthReceipt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def month_receipt_params
      params.fetch(:month_receipt, {})
    end
end
