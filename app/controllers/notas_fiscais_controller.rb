# frozen_string_literal: true

class NotasFiscaisController < ApplicationController
  # This action will show our upload form
  def index
    # Eager load the items to prevent N+1 queries in the view
    @notas_fiscais = NotaFiscal.all.includes(:item_notas)
  end

  # This action will be the target of our form
  def import
    file = params[:xml_file]
    if file.nil?
      redirect_to notas_fiscais_path, alert: 'No file selected. Please choose an XML file.'
      return
    end

    # Use our new service object
    begin
      imported_nota = NfeImportService.call(file)
      redirect_to notas_fiscais_path, notice: "Successfully imported NF-e ##{imported_nota.number}!"
    rescue ActiveRecord::RecordInvalid => e
      # Handle validation errors (e.g., duplicate access_key)
      redirect_to notas_fiscais_path, alert: "Validation Error: #{e.message}"
    rescue StandardError => e
      # Handle all other errors (parsing, etc.)
      redirect_to notas_fiscais_path, alert: "Error importing file: #{e.message}"
    end
  end
end
