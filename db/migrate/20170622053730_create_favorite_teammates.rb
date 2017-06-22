class CreateFavoriteTeammates < ActiveRecord::Migration[5.1]
  def change
    create_table :favorite_teammates do |t|
      t.references :user_one
      t.references :user_two
      t.integer :count
      t.integer :is_friend

      t.timestamps
    end
  end
end
