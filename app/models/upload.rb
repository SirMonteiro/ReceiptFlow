class Upload < ApplicationRecord
  has_one_attached :xml_file

  validates :xml_file, presence: true
end