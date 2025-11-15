class RemoverTabelaNotaFiscais < ActiveRecord::Migration[8.1]
  def change
    drop_table :nota_fiscais
  end
end