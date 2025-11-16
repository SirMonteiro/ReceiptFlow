# frozen_string_literal: true

class AddUserToDespesas < ActiveRecord::Migration[7.1]
  def change
    add_reference :despesas, :user, null: false, foreign_key: true
  end
end
