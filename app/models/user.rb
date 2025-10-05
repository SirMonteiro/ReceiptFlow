class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
end