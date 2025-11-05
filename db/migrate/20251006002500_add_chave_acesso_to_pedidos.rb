# frozen_string_literal: true

class AddChaveAcessoToPedidos < ActiveRecord::Migration[7.1]
  def change
    add_column :pedidos, :chave_acesso, :string
  end
end
