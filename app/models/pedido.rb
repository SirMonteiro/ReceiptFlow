class Pedido < ApplicationRecord
  validates :cliente, presence: true
  validates :valor, presence: true
end
