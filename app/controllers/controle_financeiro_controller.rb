class ControleFinanceiroController < ApplicationController
  before_action :require_login

  def index
    @user = current_user


    @mes_atual = Date.today.month
    @ano_atual = Date.today.year


    @meta_atual = @user.metas_mensais.find_by(mes: @mes_atual, ano: @ano_atual)
    @orcamento_atual = @user.orcamentos_mensais.find_by(mes: @mes_atual, ano: @ano_atual)


    @metas_anteriores = @user.metas_mensais.where.not(mes: @mes_atual, ano: @ano_atual)
    @orcamentos_anteriores = @user.orcamentos_mensais.where.not(mes: @mes_atual, ano: @ano_atual)


    @despesas = @user.despesas.order(data: :desc)

    # Instâncias novas para formulários
    @nova_meta = MetaMensal.new
    @novo_orcamento = OrcamentoMensal.new
    @nova_despesa = Despesa.new
  end


  def criar_meta
    @meta = current_user.metas_mensais.new(meta_params)
    if @meta.save
      redirect_to controle_financeiro_path, notice: "Meta criada com sucesso!"
    else
      redirect_to controle_financeiro_path, alert: "Erro ao criar meta."
    end
  end

  def atualizar_meta
    @meta = current_user.metas_mensais.find(params[:id])
    if @meta.update(meta_params)
      redirect_to controle_financeiro_path, notice: "Meta atualizada!"
    else
      redirect_to controle_financeiro_path, alert: "Erro ao atualizar meta."
    end
  end

  def deletar_meta
    @meta = current_user.metas_mensais.find(params[:id])
    @meta.destroy
    redirect_to controle_financeiro_path, notice: "Meta excluída!"
  end

  def criar_orcamento
    @orcamento = current_user.orcamentos_mensais.new(orcamento_params)
    if @orcamento.save
      redirect_to controle_financeiro_path, notice: "Orçamento criado!"
    else
      redirect_to controle_financeiro_path, alert: "Erro ao criar orçamento."
    end
  end

  def atualizar_orcamento
    @orcamento = current_user.orcamentos_mensais.find(params[:id])
    if @orcamento.update(orcamento_params)
      redirect_to controle_financeiro_path, notice: "Orçamento atualizado!"
    else
      redirect_to controle_financeiro_path, alert: "Erro ao atualizar orçamento."
    end
  end

  def deletar_orcamento
    @orcamento = current_user.orcamentos_mensais.find(params[:id])
    @orcamento.destroy
    redirect_to controle_financeiro_path, notice: "Orçamento excluído!"
  end

  def criar_despesa
    @despesa = current_user.despesas.new(despesa_params)
    if @despesa.save
      redirect_to controle_financeiro_path, notice: "Despesa adicionada!"
    else
      redirect_to controle_financeiro_path, alert: "Erro ao adicionar despesa."
    end
  end

  def deletar_despesa
    @despesa = current_user.despesas.find(params[:id])
    @despesa.destroy
    redirect_to controle_financeiro_path, notice: "Despesa excluída!"
  end

  private

  def meta_params
    params.require(:meta_mensal).permit(:mes, :ano, :valor_meta)
  end

  def orcamento_params
    params.require(:orcamento_mensal).permit(:mes, :ano, :valor)
  end

  def despesa_params
    params.require(:despesa).permit(:valor, :data, :descricao)
  end
end
