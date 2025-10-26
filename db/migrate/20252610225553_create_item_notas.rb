class CreateItemNotas < ActiveRecord::Migration[7.0]
  def change
    create_table :item_notas do |t|

      t.references :nota_fiscal, null: false, foreign_key: { to_table: :nota_fiscais }

      # From <det nItem="...">
      t.integer :item_number

      # From <det><prod>
      t.string :product_code
      t.text :description
      t.decimal :quantity, precision: 10, scale: 4
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end