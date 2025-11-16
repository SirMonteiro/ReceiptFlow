class DropPedidoTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :pedidos, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
