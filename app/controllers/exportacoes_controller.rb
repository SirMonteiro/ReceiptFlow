class ExportacoesController < ApplicationController
  require 'csv'

  def exportar
    if params[:format] == 'csv'
      begin
        pedidos = Pedido.all

        pedidos.each do |pedido|
          unless pedido.chave_acesso && pedido.natureza_operacao && pedido.remetente && pedido.destinatario && pedido.descricao_produtos && pedido.valores_totais && pedido.impostos && pedido.cfop && pedido.cst && pedido.ncm && pedido.transportadora && pedido.data_saida
            Rails.logger.error("Pedido inválido: ID #{pedido.id}")
            next
          end
        end

        csv_data = CSV.generate(headers: true) do |csv|
          csv << [
            'Chave de Acesso', 'Natureza da Operação', 'Remetente - Razão Social', 'Remetente - CNPJ', 'Remetente - Endereço',
            'Destinatário - Razão Social', 'Destinatário - CNPJ', 'Destinatário - Endereço',
            'Descrição dos Produtos', 'Valores Totais', 'Impostos - ICMS', 'Impostos - IPI',
            'CFOP', 'CST', 'NCM', 'Transportadora - Razão Social', 'Transportadora - CNPJ', 'Data de Saída'
          ]

          pedidos.each do |pedido|
            csv << [
              pedido.chave_acesso,
              pedido.natureza_operacao,
              pedido.remetente['razao_social'],
              pedido.remetente['cnpj'],
              pedido.remetente['endereco'],
              pedido.destinatario['razao_social'],
              pedido.destinatario['cnpj'],
              pedido.destinatario['endereco'],
              pedido.descricao_produtos.map { |p| p['nome'] }.join(', '),
              pedido.valores_totais,
              pedido.impostos['icms'],
              pedido.impostos['ipi'],
              pedido.cfop,
              pedido.cst,
              pedido.ncm,
              pedido.transportadora['razao_social'],
              pedido.transportadora['cnpj'],
              pedido.data_saida
            ]
          end
        end

        send_data csv_data, filename: "pedidos.csv", type: 'text/csv', disposition: 'attachment'
      rescue StandardError => e
        Rails.logger.error("Erro ao gerar planilha: \#{e.message}")
        render plain: "Erro ao gerar planilha. Tente novamente mais tarde.", status: :internal_server_error
      end
    else
      head :not_acceptable
    end
  end
end
