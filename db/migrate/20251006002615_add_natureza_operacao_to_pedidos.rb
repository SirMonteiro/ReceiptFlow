# frozen_string_literal: true

class AddNaturezaOperacaoToPedidos < ActiveRecord::Migration[7.1]
  def change
    add_column :pedidos, :natureza_operacao, :string
  end
end
