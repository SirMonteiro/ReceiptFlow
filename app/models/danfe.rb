# frozen_string_literal: true

class Danfe < ApplicationRecord
  self.table_name = 'danfes'
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

  scope :do_periodo, lambda { |data_inicial:, data_final:|
    where(data_saida: data_inicial..data_final)
  }

  def impostos_hash
    return {} if impostos.blank?
    return impostos if impostos.is_a?(Hash)

    # Se é uma string, tentar fazer o parse JSON
    if impostos.is_a?(String)
      begin
        first_parse = JSON.parse(impostos)
        if first_parse.is_a?(String)
          second_parse = JSON.parse(first_parse)
          return second_parse if second_parse.is_a?(Hash)
        elsif first_parse.is_a?(Hash)
          return first_parse
        end
      rescue JSON::ParserError
        Rails.logger.error "Erro ao fazer parse do JSON de impostos: #{impostos}"
      end
    end

    {}
  end

  def remetente_hash
    return {} if remetente.blank?
    return remetente if remetente.is_a?(Hash)

    if remetente.is_a?(String)
      begin
        first_parse = JSON.parse(remetente)
        if first_parse.is_a?(String)
          second_parse = JSON.parse(first_parse)
          return second_parse if second_parse.is_a?(Hash)
        elsif first_parse.is_a?(Hash)
          return first_parse
        end
      rescue JSON::ParserError
        Rails.logger.error "Erro ao fazer parse do JSON de remetente: #{remetente}"
      end
    end

    {}
  end

  def destinatario_hash
    return {} if destinatario.blank?
    return destinatario if destinatario.is_a?(Hash)

    if destinatario.is_a?(String)
      begin
        first_parse = JSON.parse(destinatario)
        if first_parse.is_a?(String)
          second_parse = JSON.parse(first_parse)
          return second_parse if second_parse.is_a?(Hash)
        elsif first_parse.is_a?(Hash)
          return first_parse
        end
      rescue JSON::ParserError
        Rails.logger.error "Erro ao fazer parse do JSON de destinatario: #{destinatario}"
      end
    end

    {}
  end

  # Métodos auxiliares para acessar informações específicas
  def remetente_razao_social
    remetente_hash['razao_social']
  end

  def destinatario_razao_social
    destinatario_hash['razao_social']
  end

  def self.faturamento_por_mes(danfes)
    resultado = {}

    meses_pt = {
      'January' => 'Janeiro',
      'February' => 'Fevereiro',
      'March' => 'Março',
      'April' => 'Abril',
      'May' => 'Maio',
      'June' => 'Junho',
      'July' => 'Julho',
      'August' => 'Agosto',
      'September' => 'Setembro',
      'October' => 'Outubro',
      'November' => 'Novembro',
      'December' => 'Dezembro'
    }

    danfes.each do |danfe|
      mes_en = danfe.data_saida.strftime('%B')
      mes_pt = meses_pt[mes_en]
      ano = danfe.data_saida.strftime('%Y')

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
      'January' => 'Janeiro',
      'February' => 'Fevereiro',
      'March' => 'Março',
      'April' => 'Abril',
      'May' => 'Maio',
      'June' => 'Junho',
      'July' => 'Julho',
      'August' => 'Agosto',
      'September' => 'Setembro',
      'October' => 'Outubro',
      'November' => 'Novembro',
      'December' => 'Dezembro'
    }

    danfes.each do |danfe|
      mes_en = danfe.data_saida.strftime('%B')
      mes_pt = meses_pt[mes_en]
      ano = danfe.data_saida.strftime('%Y')

      chave = "#{mes_pt}/#{ano}"

      impostos_data = danfe.impostos_hash
      icms = (impostos_data['icms'] || 0).to_f
      ipi = (impostos_data['ipi'] || 0).to_f
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

    resultado.each_value do |dados|
      dados[:percentual] = (dados[:total] / dados[:valor_vendas] * 100).round(2) if dados[:valor_vendas].positive?
    end

    resultado
  end

  def self.impostos_por_cliente(danfes)
    resultado = {}

    danfes.each do |danfe|
      impostos_data = danfe.impostos_hash
      icms = (impostos_data['icms'] || 0).to_f
      ipi = (impostos_data['ipi'] || 0).to_f
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

    resultado.each_value do |dados|
      dados[:percentual] = (dados[:total] / dados[:valor_vendas] * 100).round(2) if dados[:valor_vendas].positive?
    end

    resultado
  end

  def self.total_impostos(danfes)
    total = 0
    danfes.each do |danfe|
      impostos_data = danfe.impostos_hash
      icms = (impostos_data['icms'] || 0).to_f
      ipi = (impostos_data['ipi'] || 0).to_f
      total += icms + ipi
    end
    total
  end
end
