# frozen_string_literal: true

class CreateDanfes < ActiveRecord::Migration[7.1]
  def change
    create_table :danfes do |t|
      t.references :user, null: false, foreign_key: true

      t.string :cliente, null: false
      t.decimal :valor, null: false
      t.string :chave_acesso, null: false
      t.string :natureza_operacao, null: false
      t.string :remetente, null: false
      t.string :destinatario, null: false
      t.text :descricao_produtos, null: false
      t.decimal :valores_totais, null: false
      t.decimal :impostos, null: false
      t.string :cfop, null: false
      t.string :cst, null: false
      t.string :ncm, null: false
      t.string :transportadora, null: false
      t.date :data_saida, null: false
      t.timestamps
    end
  end
end
