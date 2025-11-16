# frozen_string_literal: true

class RemoveStreakCreditoNivelFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :streak, :integer
    remove_column :users, :credito, :integer
    remove_column :users, :nivel, :integer
  end
end
