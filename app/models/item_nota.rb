# frozen_string_literal: true

class ItemNota < ApplicationRecord
  # --- ADD THIS LINE ---
  # Tell Rails the table name is 'item_notas' (plural)
  self.table_name = 'item_notas'
  # ---------------------

  # Each item belongs to one invoice
  belongs_to :nota_fiscal,
             class_name: 'NotaFiscal'
end
