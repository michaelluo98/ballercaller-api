class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.references :user_one
      t.references :user_two

      t.timestamps
    end
  end
end
