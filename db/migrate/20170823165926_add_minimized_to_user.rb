class AddMinimizedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :minimized, :boolean
  end
end
