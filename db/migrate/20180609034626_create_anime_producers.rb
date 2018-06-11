class CreateAnimeProducers < ActiveRecord::Migration[5.2]
  def change
    create_table :anime_producers do |t|
      t.integer :role, null: false
      t.belongs_to :anime, foreign_key: true
      t.belongs_to :producer, foreign_key: true

      t.timestamps
    end
  end
end
