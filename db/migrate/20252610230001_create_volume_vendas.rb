class CreateVolumeVendas < ActiveRecord::Migration[7.1]
  def change
    create_table :volume_vendas do |t|
      t.string :loja, null: false
      t.string :cnpj
      t.date :data_inicial, null: false
      t.date :data_final, null: false
      t.decimal :valor_total, precision: 15, scale: 2, null: false, default: 0
      t.integer :quantidade_notas, null: false, default: 0
      t.decimal :ticket_medio, precision: 15, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :volume_vendas, [:loja, :data_inicial, :data_final], name: "index_volume_vendas_on_store_and_period"
  end
end
