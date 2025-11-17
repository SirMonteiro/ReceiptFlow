# frozen_string_literal: true

class NotasFiscaisController < ApplicationController
  # Assume-se que 'before_action :require_login' (ou similar)
  # esteja protegendo este controlador.

  def index
    @notas_fiscais = NotaFiscal.all.includes(:item_notas)
  end

  def import
    file = params[:xml_file]
    if file.nil?
      redirect_to notas_fiscais_path, alert: 'Nenhum arquivo selecionado. Por favor escolha um arquivo XML.'
      return
    end

    begin
      # --- MUDANÇA AQUI ---
      # Passe o 'current_user' para o serviço
      imported_nota = NfeImportService.call(file, current_user)
      # --- FIM DA MUDANÇA ---

      redirect_to notas_fiscais_path, notice: "NF-e ##{imported_nota.number} importada com sucesso!"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to notas_fiscais_path, alert: "Erro de validação: #{e.message}"
    rescue StandardError => e
      redirect_to notas_fiscais_path, alert: "Erro na importação do arquivo: #{e.message}"
    end
  end
end
