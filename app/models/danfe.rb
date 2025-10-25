class Danfe < ApplicationRecord
    self.table_name = "danfes"
    belongs_to :user
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
  
  def self.faturamento_por_mes(danfes)
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
    
    danfes.each do |danfe|
      mes_en = danfe.data_saida.strftime("%B")
      mes_pt = meses_pt[mes_en]
      ano = danfe.data_saida.strftime("%Y")
      
      chave = "#{mes_pt}/#{ano}"
      resultado[chave] ||= 0
      resultado[chave] += danfe.valor
    end
    
    resultado
  end
  
  def self.faturamento_por_cliente(danfes)
    resultado = {}
    
    danfes.each do |danfe|
      resultado[danfe.cliente] ||= 0
      resultado[danfe.cliente] += danfe.valor
    end
    
    resultado
  end
  
  def self.impostos_por_mes(danfes)
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
    
    danfes.each do |danfe|
      mes_en = danfe.data_saida.strftime("%B")
      mes_pt = meses_pt[mes_en]
      ano = danfe.data_saida.strftime("%Y")
      
      chave = "#{mes_pt}/#{ano}"
      
      icms = danfe.impostos.is_a?(Hash) ? (danfe.impostos['icms'] || 0) : 0
      ipi = danfe.impostos.is_a?(Hash) ? (danfe.impostos['ipi'] || 0) : 0
      total_impostos = icms + ipi
      
      if resultado[chave]
        resultado[chave][:icms] += icms
        resultado[chave][:ipi] += ipi
        resultado[chave][:total] += total_impostos
        resultado[chave][:valor_vendas] += danfe.valor
      else
        resultado[chave] = {
          icms: icms,
          ipi: ipi,
          total: total_impostos,
          valor_vendas: danfe.valor,
          percentual: 0
        }
      end
    end
    
    resultado.each do |mes, dados|
      dados[:percentual] = (dados[:total] / dados[:valor_vendas] * 100).round(2) if dados[:valor_vendas] > 0
    end
    
    resultado
  end
  
  def self.impostos_por_cliente(danfes)
    resultado = {}
    
    danfes.each do |danfe|
      icms = danfe.impostos.is_a?(Hash) ? (danfe.impostos['icms'] || 0) : 0
      ipi = danfe.impostos.is_a?(Hash) ? (danfe.impostos['ipi'] || 0) : 0
      total_impostos = icms + ipi
      
      if resultado[danfe.cliente]
        resultado[danfe.cliente][:icms] += icms
        resultado[danfe.cliente][:ipi] += ipi
        resultado[danfe.cliente][:total] += total_impostos
        resultado[danfe.cliente][:valor_vendas] += danfe.valor
      else
        resultado[danfe.cliente] = {
          icms: icms,
          ipi: ipi,
          total: total_impostos,
          valor_vendas: danfe.valor,
          percentual: 0
        }
      end
    end
    
    resultado.each do |cliente, dados|
      dados[:percentual] = (dados[:total] / dados[:valor_vendas] * 100).round(2) if dados[:valor_vendas] > 0
    end
    
    resultado
  end
  
  def self.total_impostos(danfes)
    total = 0
    danfes.each do |danfe|
      icms = danfe.impostos.is_a?(Hash) ? (danfe.impostos['icms'] || 0) : 0
      ipi = danfe.impostos.is_a?(Hash) ? (danfe.impostos['ipi'] || 0) : 0
      total += icms + ipi
    end
    total
  end
end