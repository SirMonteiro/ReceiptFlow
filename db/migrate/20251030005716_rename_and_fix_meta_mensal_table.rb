# frozen_string_literal: true

class RenameAndFixMetaMensalTable < ActiveRecord::Migration[7.1]
  def change
    rename_table :meta_mensals, :metas_mensais
    add_column :metas_mensais, :ano, :integer
    add_reference :metas_mensais, :user, foreign_key: true
    add_index :metas_mensais, %i[user_id mes ano], unique: true
  end
end
