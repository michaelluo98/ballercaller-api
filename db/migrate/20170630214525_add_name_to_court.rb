class AddNameToCourt < ActiveRecord::Migration[5.1]
  def change
    add_column :courts, :name, :string
  end
end
