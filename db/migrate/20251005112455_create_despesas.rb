# frozen_string_literal: true

class CreateDespesas < ActiveRecord::Migration[7.1]
  def change
    create_table :despesas do |t|
      t.decimal :valor
      t.date :data
      t.string :descricao

      t.timestamps
    end
  end
end
