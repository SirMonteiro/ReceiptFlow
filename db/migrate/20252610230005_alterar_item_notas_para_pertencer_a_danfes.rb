# db/migrate/20252610230005_alterar_item_notas_para_pertencer_a_danfes.rb
class AlterarItemNotasParaPertencerADanfes < ActiveRecord::Migration[8.1]
  def change
    # 1. Remover a chave estrangeira antiga
    # (Usamos 'if_exists' para tornar seguro rodar de novo)
    remove_foreign_key "item_notas", "nota_fiscais", if_exists: true

    # 2. Renomear a coluna
    # (Verificamos se a coluna antiga ainda existe)
    if column_exists?("item_notas", "nota_fiscal_id")
      rename_column "item_notas", "nota_fiscal_id", "danfe_id"
    end

    # --- INÍCIO DA CORREÇÃO ---
    #
    # 3. LIMPAR DADOS ÓRFÃOS
    #    Antes de adicionar a nova chave, precisamos excluir
    #    todos os 'item_notas' que apontam para 'danfe_id's
    #    que NÃO existem na tabela 'danfes'.
    #
    #    !! AVISO: Isso exclui dados permanentemente !!
    #
    execute <<-SQL
      DELETE FROM item_notas
      WHERE danfe_id NOT IN (SELECT id FROM danfes);
    SQL
    
    # --- FIM DA CORREÇÃO ---

    # 4. Adicionar a nova chave estrangeira (agora vai funcionar)
    add_foreign_key "item_notas", "danfes", column: "danfe_id"
  end
end