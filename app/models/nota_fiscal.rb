# frozen_string_literal: true

class NotaFiscal < ApplicationRecord
  # --- ADD THIS LINE ---
  # Tell Rails the table name is 'nota_fiscais' (with an 'i')
  # not 'nota_fiscals' (with an 'l')
  self.table_name = 'nota_fiscais'
  # ---------------------

  # An invoice has many items. If we delete the invoice,
  # it should also delete all its associated items.
  has_many :item_notas,
           class_name: 'ItemNota',
           dependent: :destroy

  validates :access_key, presence: true, uniqueness: true
  validates :number, presence: true
end
