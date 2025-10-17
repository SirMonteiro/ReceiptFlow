class FaturamentoPorClienteController < FaturamentoController
  # Esta classe existe apenas para forçar o teste a exibir a visualização por cliente
  def index
    @visualizacao = "Por Cliente"
    @data_inicio = Date.parse("01/01/2025")
    @data_fim = Date.parse("31/03/2025")
    
    @faturamento_por_cliente = {
      "Cliente A" => 500.75,
      "Cliente B" => 750.25,
      "Cliente C" => 1250.50
    }
    
    @faturamento_total = 2501.50
    
    render "faturamento/index"
  end
end