class Despesa < ApplicationRecord
    belongs_to :user
    validates :valor, :data, presence: true
end
