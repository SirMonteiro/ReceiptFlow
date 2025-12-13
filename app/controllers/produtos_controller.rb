# frozen_string_literal: true

class ProdutosController < ApplicationController
  before_action :set_filtros, only: [:index]
  before_action :set_danfes, only: [:index, :exportar]

  def index
    if @danfes.empty?
      @sem_dados = true
      return
    end

    @produtos_estatisticas = calcular_estatisticas_produtos
  end

  def exportar
    if @danfes.empty?
      redirect_to produtos_path, alert: 'Não há dados para exportar'
      return
    end

    produtos_estatisticas = calcular_estatisticas_produtos

    csv_data = gerar_csv(produtos_estatisticas)

    send_data csv_data,
              filename: 'produtos.csv',
              type: 'text/csv',
              disposition: 'attachment'
  end

  private

  def set_filtros
    @visualizacao = params[:visualizacao] || 'Por Produto'
    @data_inicio = params[:data_inicio].present? ? Date.parse(params[:data_inicio]) : Date.today.beginning_of_year
    @data_fim = params[:data_fim].present? ? Date.parse(params[:data_fim]) : Date.today
  end

  def set_danfes
    return redirect_to '/login' unless current_user
    @danfes = current_user.danfes
                          .where(data_saida: @data_inicio..@data_fim)
                          .order(data_saida: :desc)
  end

  def calcular_estatisticas_produtos
    produtos = {}

    @danfes.each do |danfe|
      chave = @visualizacao == 'Por NCM' ? danfe.ncm : danfe.descricao_produtos

      if produtos[chave]
        produtos[chave][:valor_total] += danfe.valores_totais
        produtos[chave][:quantidade] += 1
      else
        produtos[chave] = {
          descricao: danfe.descricao_produtos,
          ncm: danfe.ncm,
          valor_total: danfe.valores_totais,
          quantidade: 1
        }
      end
    end

    # Ordenar por valor total decrescente
    produtos.sort_by { |_k, v| -v[:valor_total] }.to_h
  end

  def gerar_csv(produtos_estatisticas)
    CSV.generate(headers: true) do |csv|
      csv << ['Produto', 'NCM', 'Valor Total', 'Quantidade', 'Valor Médio']

      produtos_estatisticas.each do |chave, dados|
        valor_medio = dados[:valor_total] / dados[:quantidade]
        csv << [
          dados[:descricao],
          dados[:ncm],
          dados[:valor_total],
          dados[:quantidade],
          valor_medio.round(2)
        ]
      end
    end
  end
end
