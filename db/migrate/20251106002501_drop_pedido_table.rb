class DropPedidoTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :pedido, if_exists: true
  end
end
