class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :user, foreign_key: true
      t.references :friend
      t.integer :status

      t.timestamps
    end
  end
end
