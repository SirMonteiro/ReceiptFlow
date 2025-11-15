class AddNumberToDanfes < ActiveRecord::Migration[8.1]
  def change
    add_column :danfes, :number, :integer
  end
end
