class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.references :game_mod
      t.integer :mode
      t.datetime :start_time
      t.text :extra_info
      t.integer :status
      t.references :court

      t.timestamps
    end
  end
end
