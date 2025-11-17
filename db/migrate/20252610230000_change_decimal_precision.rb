# frozen_string_literal: true

class ChangeDecimalPrecision < ActiveRecord::Migration[7.0]
  def change
    # --- For ItemNotas table ---
    # The XML <qCom>1000000.0000</qCom> (7 digits) failed :quantity (6 digits).
    # The XML <vProd>10000000.00</vProd> (8 digits) would have failed :total_price (8 digits).

    # Let's change them to precision 14, which allows 10-12 digits.
    change_column :item_notas, :quantity,    :decimal, precision: 14, scale: 4
    change_column :item_notas, :unit_price,  :decimal, precision: 14, scale: 2
    change_column :item_notas, :total_price, :decimal, precision: 14, scale: 2

    # --- For NotaFiscais table ---
    # The XML <vNF>20000000.00</vNF> (8 digits) would have also failed
    # :total_value (8 digits) on the main invoice.

    # Let's change these to precision 14 as well.
    change_column :nota_fiscais, :total_value,    :decimal, precision: 14, scale: 2
    change_column :nota_fiscais, :products_value, :decimal, precision: 14, scale: 2
  end
end
