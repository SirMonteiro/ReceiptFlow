class AddMissingNfeFieldsToDanfes < ActiveRecord::Migration[8.1]
  def change
    add_column :danfes, :series, :integer
    add_column :danfes, :emitter_cnpj, :string
    add_column :danfes, :recipient_cnpj, :string
    add_column :danfes, :products_value, :decimal, precision: 14, scale: 2
  end
end
