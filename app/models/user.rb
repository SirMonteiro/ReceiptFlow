class User < ApplicationRecord
  has_secure_password

  has_many :danfes

  validates :email, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :password, length: { minimum: 6, message: "deve ter pelo menos 6 caracteres" }
end