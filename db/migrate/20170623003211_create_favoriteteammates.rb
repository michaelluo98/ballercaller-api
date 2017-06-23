class CreateFavoriteteammates < ActiveRecord::Migration[5.1]
  def change
    create_table :favoriteteammates do |t|
      t.references :user, foreign_key: true
      t.references :teammate
      t.integer :interactions
      t.boolean :is_friend

      t.timestamps
    end
  end
end
