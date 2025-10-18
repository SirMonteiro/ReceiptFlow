class Pedido < ApplicationRecord
  self.table_name = 'pedido'
  # Validações para garantir que os campos obrigatórios estejam preenchidos
  validates :cliente, presence: true
  validates :valor, presence: true

  # Validações específicas para os campos da DANFE
  validates :chave_acesso, presence: true
  validates :natureza_operacao, presence: true
  validates :remetente, presence: true
  validates :destinatario, presence: true
  validates :descricao_produtos, presence: true
  validates :valores_totais, presence: true
  validates :impostos, presence: true
  validates :cfop, presence: true
  validates :cst, presence: true
  validates :ncm, presence: true
  validates :transportadora, presence: true
  validates :data_saida, presence: true

  # Métodos auxiliares para acessar informações específicas
  def remetente_razao_social
    remetente['razao_social'] if remetente.is_a?(Hash)
  end

  def destinatario_razao_social
    destinatario['razao_social'] if destinatario.is_a?(Hash)
  end
  
  def self.faturamento_por_mes(pedidos)
    resultado = {}
    
    meses_pt = {
      "January" => "Janeiro",
      "February" => "Fevereiro",
      "March" => "Março",
      "April" => "Abril",
      "May" => "Maio",
      "June" => "Junho",
      "July" => "Julho",
      "August" => "Agosto",
      "September" => "Setembro",
      "October" => "Outubro",
      "November" => "Novembro",
      "December" => "Dezembro"
    }
    
    pedidos.each do |pedido|
      mes_en = pedido.data_saida.strftime("%B")
      mes_pt = meses_pt[mes_en]
      ano = pedido.data_saida.strftime("%Y")
      
      chave = "#{mes_pt}/#{ano}"
      resultado[chave] ||= 0
      resultado[chave] += pedido.valor
    end
    
    resultado
  end
  
  def self.faturamento_por_cliente(pedidos)
    resultado = {}
    
    pedidos.each do |pedido|
      resultado[pedido.cliente] ||= 0
      resultado[pedido.cliente] += pedido.valor
    end
    
    resultado
  end
end
