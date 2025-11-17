# frozen_string_literal: true

class CreateMonthReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :month_receipts, &:timestamps
  end
end
