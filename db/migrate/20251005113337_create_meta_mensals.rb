# frozen_string_literal: true

class CreateMetaMensals < ActiveRecord::Migration[7.1]
  def change
    create_table :meta_mensals do |t|
      t.integer :mes
      t.decimal :valor_meta

      t.timestamps
    end
  end
end
