class User < ApplicationRecord
  has_secure_password

  has_many :danfes
  has_many :metas_mensais, class_name: "MetaMensal"
  has_many :orcamentos_mensais, class_name: "OrcamentoMensal"
  has_many :despesas

  validates :email, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :password, length: { minimum: 6, message: "deve ter pelo menos 6 caracteres" }
end