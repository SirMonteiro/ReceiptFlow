class CreateOrcamentoMensals < ActiveRecord::Migration[7.1]
  def change
    create_table :orcamento_mensals do |t|
      t.integer :mes
      t.integer :ano
      t.decimal :valor
      t.references :user, null: false, foreign_key: true
    


      t.timestamps
    end
  end
end
