class GraficosController < ApplicationController
  before_action :require_login, only: [:index]
  def index
    @user = current_user

    # vendas nos últimos 6 meses (contando com o mês atual)
    @vendas = @user.danfes
              .where("natureza_operacao ILIKE ?", 'venda')
              .where("data_saida >= ?", 5.months.ago.beginning_of_month) # como que isso existe
              .select("DATE_TRUNC('month', data_saida) AS mes_ano, SUM(valor) AS total")
              .group("mes_ano")
              .order("mes_ano ASC")
              # look at my ruby daaaawg ts just sql :(

    @labels = @vendas.map { |v| v.mes_ano.strftime("%m/%Y") }
     
    @vendas_values = @vendas.map(&:total)

    # despesas nos últimos 6 meses
    @despesas = @user.despesas
                .where("data >= ?", 5.months.ago.beginning_of_month)
                .select("DATE_TRUNC('month', data) AS mes_ano, SUM(valor) AS total")
                .group("mes_ano")
                .order("mes_ano ASC")

    @despesas_values = @despesas.map(&:total)


    # últimos 6 orçamentos (verificação de datas deve ser feita posteriormente)
    @orcamentos = @user.orcamentos_mensais
              .order(ano: :desc, mes: :desc)
              .limit(6)

    @orcamentos_values = @labels.map do |label|
      mes, ano = label.split("/").map(&:to_i)
      orcamento = @orcamentos.find { |m| m.mes == mes && m.ano == ano }
      orcamento&.valor.to_f || 0
    end

    # últimas 6 metas (verificação de datas deve ser feita posteriormente)
    @metas = @user.metas_mensais
              .order(ano: :desc, mes: :desc)
              .limit(6)

    @metas_values = @labels.map do |label|
      mes, ano = label.split("/").map(&:to_i)
      meta = @metas.find { |m| m.mes == mes && m.ano == ano }
      meta&.valor_meta.to_f || 0
    end

    # serão usados no gráfico de pizza
    @mes_atual = Date.today.month
    @ano_atual = Date.today.year
    @meta_atual = @user.metas_mensais.find_by(mes: @mes_atual, ano: @ano_atual)
    @vendas_atuais = @user.danfes.where("natureza_operacao ILIKE ?", 'venda')
                        .where("EXTRACT(MONTH FROM data_saida) = ?", @mes_atual)
                        .where("EXTRACT(YEAR FROM data_saida) = ?", @ano_atual)
                        .sum(:valor)
    if @meta_atual
      @restante = [@meta_atual.valor_meta - @vendas_atuais, 0].max
    end
  end
end


