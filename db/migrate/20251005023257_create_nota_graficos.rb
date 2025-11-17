# frozen_string_literal: true

class CreateNotaGraficos < ActiveRecord::Migration[7.1]
  def change
    create_table :nota_graficos do |t|
      t.decimal :valor
      t.string :tipo
      t.date :data

      t.timestamps
    end
  end
end
