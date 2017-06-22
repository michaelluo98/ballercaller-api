class CreateDirectMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :direct_messages do |t|
      t.text :message
      t.references :sender
      t.references :recipient

      t.timestamps
    end
  end
end
