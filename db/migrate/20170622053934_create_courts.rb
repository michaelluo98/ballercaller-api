class CreateCourts < ActiveRecord::Migration[5.1]
  def change
    create_table :courts do |t|
      t.string :address
      t.string :postal_code
      t.string :city

      t.timestamps
    end
  end
end
