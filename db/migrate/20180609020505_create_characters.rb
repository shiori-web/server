class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :avatar
      t.integer :gender
      t.hstore :info

      t.timestamps
    end
  end
end
