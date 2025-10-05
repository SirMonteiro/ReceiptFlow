class Pedido < ApplicationRecord
  validates :cliente, presence: true
  validates :valor, presence: true

  # Campos adicionais da DANFE
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

  # Métodos auxiliares (se necessário)
  def remetente_razao_social
    remetente['razao_social'] if remetente.is_a?(Hash)
  end

  def destinatario_razao_social
    destinatario['razao_social'] if destinatario.is_a?(Hash)
  end
end
