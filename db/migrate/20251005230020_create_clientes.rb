# frozen_string_literal: true

class CreateClientes < ActiveRecord::Migration[7.1]
  def change
    create_table :clientes do |t|
      t.string :codigo
      t.string :descricao

      t.timestamps
    end
  end
end
