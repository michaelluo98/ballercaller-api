class AddSettingToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :setting, :boolean
  end
end
