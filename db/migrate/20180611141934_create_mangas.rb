class CreateMangas < ActiveRecord::Migration[5.2]
  def change
    create_table :mangas do |t|
      t.hstore :titles, null: false
      t.string :slug, null: false
      t.text :desc
      t.date :started_at
      t.date :ended_at
      t.integer :subtype, default: 0
      t.integer :age_rating
      t.string :age_rating_guide
      t.string :sub_titles, array: true

      t.timestamps
    end
    add_index :mangas, :slug, unique: true
  end
end
