class CreatePedidos < ActiveRecord::Migration[7.1]
  def change
    create_table :pedidos, if_not_exists: true do |t|
      t.string :cliente
      t.decimal :valor

      t.timestamps
    end
  end
end
