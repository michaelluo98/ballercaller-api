class AddProvinceToCourt < ActiveRecord::Migration[5.1]
  def change
    add_column :courts, :province, :string
  end
end
