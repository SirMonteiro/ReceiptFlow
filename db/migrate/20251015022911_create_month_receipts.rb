class CreateMonthReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :month_receipts do |t|

      t.timestamps
    end
  end
end
