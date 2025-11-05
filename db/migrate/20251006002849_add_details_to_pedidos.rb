# frozen_string_literal: true

class AddDetailsToPedidos < ActiveRecord::Migration[7.1]
  def change
    add_column :pedidos, :descricao_produtos, :text
    add_column :pedidos, :remetente, :string
  end
end
