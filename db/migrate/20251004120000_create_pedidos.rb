class CreatePedidos < ActiveRecord::Migration[7.1]
  def change
    create_table :pedidos do |t|
      t.string :cliente, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false

      # Campos adicionais da DANFE
      t.string :chave_acesso
      t.string :natureza_operacao
      t.jsonb :remetente
      t.jsonb :destinatario
      t.jsonb :descricao_produtos
      t.decimal :valores_totais, precision: 15, scale: 2
      t.jsonb :impostos
      t.string :cfop
      t.string :cst
      t.string :ncm
      t.jsonb :transportadora
      t.datetime :data_saida

      t.timestamps
    end
  end
end
