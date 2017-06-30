class AddLatitudeAndLongitudeToCourt < ActiveRecord::Migration[5.1]
  def change
    add_column :courts, :latitude, :float
    add_column :courts, :longitude, :float
  end
end
