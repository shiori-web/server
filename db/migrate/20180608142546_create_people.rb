class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :avatar
      t.integer :gender
      t.hstore :info

      t.timestamps
    end
  end
end
