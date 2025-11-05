# frozen_string_literal: true

class Despesa < ApplicationRecord
  belongs_to :user
  validates :valor, :data, presence: true
  validates :valor, numericality: { greater_than_or_equal_to: 0 }
end
