class CreateUsers < ActiveRecord::Migration[7.1]
   create_table :users do |t|
      t.string :email, null: false
      t.string :nome, null: false
      t.string :password_digest, null: false
      t.integer :credito, default: 0
      t.integer :streak, default: 0
      t.integer :nivel, default: 1

      t.timestamps
  end
end