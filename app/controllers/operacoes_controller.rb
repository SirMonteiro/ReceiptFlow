class OperacoesController < ApplicationController
  before_action :require_login, only: [:index]

  TIPOS_OPERACAO = [
    'Venda',
    'Devolução',
    'Serviço',
    'Transferência / Remessa',
    'Complementar'
  ].freeze

  def index
    @tipos_operacao = TIPOS_OPERACAO

    # parâmetro vindo da view
    @operacao_selecionada = params[:operacao]

    # consulta inicial
    @danfes = current_user.danfes

    # filtra se o usuário escolheu uma operação
    return unless @operacao_selecionada.present?

    @danfes = @danfes.where(natureza_operacao: @operacao_selecionada)
  end
end
