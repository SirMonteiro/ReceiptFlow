class CreateNotaFiscais < ActiveRecord::Migration[7.0]
    def change
      create_table :nota_fiscais do |t|
        # From <infNFe Id="...">
        t.string :access_key, index: { unique: true }
  
        # From <ide>
        t.integer :number
        t.integer :series
        t.date :emission_date
  
        # From <emit>
        t.string :emitter_name
        t.string :emitter_cnpj
  
        # From <dest>
        t.string :recipient_name
        t.string :recipient_cnpj
  
        # From <total><ICMSTot>
        t.decimal :total_value, precision: 10, scale: 2
        t.decimal :products_value, precision: 10, scale: 2
  
        t.timestamps
      end
    end
  end
  