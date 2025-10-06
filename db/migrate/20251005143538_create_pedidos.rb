class CreatePedidos < ActiveRecord::Migration[7.1]
  def change
    create_table :pedidos do |t|
      t.string :cliente
      t.decimal :valor

      t.timestamps
    end
  end
end
