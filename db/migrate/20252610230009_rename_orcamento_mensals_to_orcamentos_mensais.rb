class RenameOrcamentoMensalsToOrcamentosMensais < ActiveRecord::Migration[8.1]
  def change
    rename_table :orcamento_mensals, :orcamentos_mensais
  end
end
