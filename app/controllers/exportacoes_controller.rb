class ExportacoesController < ApplicationController
  require 'csv'

  def exportar
    if params[:format] == 'csv'
      begin
        pedidos = Pedido.all
        csv_data = CSV.generate(headers: true) do |csv|
          # Cabeçalho esperado nos testes
          csv << ['Cliente', 'Valor']

          # Dados dos pedidos
          pedidos.each do |pedido|
            csv << [pedido.cliente, pedido.valor]
          end
        end

        send_data csv_data, filename: "pedidos.csv", type: 'text/csv', disposition: 'attachment'
      rescue StandardError => e
        Rails.logger.error("Erro ao gerar planilha: \\#{e.message}")
        render plain: "Erro ao gerar planilha. Tente novamente mais tarde.", status: :internal_server_error
      end
    else
      head :not_acceptable
    end
  end
end
