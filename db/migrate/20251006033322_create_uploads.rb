class CreateUploads < ActiveRecord::Migration[7.1] # <-- THIS NAME MUST BE CORRECT
  def change
    create_table :uploads do |t|
      t.string   :file_name, null: false
      t.string   :file_type, null: false
      t.binary   :file_data, null: false

      t.timestamps
    end
  end
end