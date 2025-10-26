class Product < ApplicationRecord
    # We can add validations to ensure our data from the XML is clean
    validates :name, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
  end
  