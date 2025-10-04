class CreatePedidos < ActiveRecord::Migration[7.1]
  def change
    create_table :pedidos do |t|
      t.string :cliente, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
