class AddDanfeFieldsToPedidos < ActiveRecord::Migration[7.1]
  def change
    add_column :pedidos, :chave_acesso, :string
    add_column :pedidos, :natureza_operacao, :string
    add_column :pedidos, :remetente, :jsonb
    add_column :pedidos, :destinatario, :jsonb
    add_column :pedidos, :descricao_produtos, :jsonb
    add_column :pedidos, :valores_totais, :decimal, precision: 15, scale: 2
    add_column :pedidos, :impostos, :jsonb
    add_column :pedidos, :cfop, :string
    add_column :pedidos, :cst, :string
    add_column :pedidos, :ncm, :string
    add_column :pedidos, :transportadora, :jsonb
    add_column :pedidos, :data_saida, :datetime
  end
end
