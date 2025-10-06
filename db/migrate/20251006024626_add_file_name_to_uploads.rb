class AddFileNameToUploads < ActiveRecord::Migration[7.1]
  def change
    add_column :uploads, :file_name, :string, null: false
  end
end