class MetaMensal < ApplicationRecord
  self.table_name = "metas_mensais"
  belongs_to :user

  validates :mes, :ano, :valor_meta, presence: true
  validates :valor_meta, numericality: { greater_than_or_equal_to: 0 }
  validates :mes, inclusion: { in: 1..12, message: "o mês deve ser válido" }
  validates :ano, numericality: { greater_than_or_equal_to: 0 }
  validates :mes, uniqueness: { scope: [:ano, :user_id] }
end
