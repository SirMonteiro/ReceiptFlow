# frozen_string_literal: true

class OrcamentoMensal < ApplicationRecord
  belongs_to :user
  self.table_name = 'orcamentos_mensais'

  validates :mes, :ano, :valor, presence: true
  validates :valor, numericality: { greater_than_or_equal_to: 0 }
  validates :mes, inclusion: { in: 1..12, message: 'o mês deve ser válido' }
  validates :ano, numericality: { greater_than_or_equal_to: 0 }
  validates :mes, uniqueness: { scope: %i[ano user_id] } # impede que o usuário tenha dois orçamentos
end
