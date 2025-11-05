# frozen_string_literal: true

class GraficosController < ApplicationController
  before_action :require_login, only: [:index]
  def index
    notas = NotaGrafico.all
    despesas = Despesa.all
    meta = MetaMensal.last

    if notas.empty?
      @nenhum_dado = true
      return
    end

    # Cenário: Exibir gráfico de vendas mensais (gráfico de barras)
    @ganhos_mensais = notas.group_by { |n| n.data.strftime('%B') }
                           .transform_values { |ns| ns.sum(&:valor) }

    # Cenário: Exibir gráfico de despesas/ganhos (gráfico de barras duplas)
    @lucros = @ganhos_mensais
    @despesas = despesas.group_by { |d| d.data.strftime('%B') }
                        .transform_values { |ds| ds.sum(&:valor) }

    # Cenário: Exibir gráfico de vendas/meta (gráfico de pizza)
    total_arrecadado = notas.sum(&:valor)
    @vendas_meta = ({ 'Arrecadado' => total_arrecadado, 'Meta' => meta.valor_meta } if meta.present?)
  end
end
