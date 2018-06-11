class CreateCasts < ActiveRecord::Migration[5.2]
  def change
    create_table :casts do |t|
      t.integer :role, null: false
      t.integer :locale, null: false
      t.belongs_to :anime, foreign_key: true
      t.belongs_to :person, foreign_key: true
      t.belongs_to :character, foreign_key: true

      t.timestamps
    end
  end
end
