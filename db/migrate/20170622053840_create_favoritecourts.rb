class CreateFavoritecourts < ActiveRecord::Migration[5.1]
  def change
    create_table :favoritecourts do |t|
      t.references :user
      t.references :court
      t.integer :count

      t.timestamps
    end
  end
end
