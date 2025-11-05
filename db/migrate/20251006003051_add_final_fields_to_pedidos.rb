# frozen_string_literal: true

class AddFinalFieldsToPedidos < ActiveRecord::Migration[7.1]
  def change
    add_column :pedidos, :valores_totais, :string
    add_column :pedidos, :destinatario, :string
  end
end
