class ChangeImpostosToTextInDanfes < ActiveRecord::Migration[7.1]
  def up
    # Alterar o tipo do campo impostos de decimal para text
    change_column :danfes, :impostos, :text
  end
  
  def down
    # Reverter para decimal (atenção: isso pode causar perda de dados)
    change_column :danfes, :impostos, :decimal
  end
end
