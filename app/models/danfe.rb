class Danfe < ApplicationRecord
    self.table_name = "danfes"
    belongs_to :user
end