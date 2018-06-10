class CreateAnimes < ActiveRecord::Migration[5.2]
  def change
    create_table :animes do |t|
      t.hstore :titles, null: false
      t.string :slug, null: false
      t.text :desc
      t.date :started_at
      t.date :ended_at
      t.integer :show_type, default: 0
      t.integer :age_rating
      t.string :age_rating_guide
      t.string :adaptation
      t.integer :episode_duration
      t.string :sub_titles, array: true
      t.string :cover_upload_url

      t.timestamps
    end
    add_index :animes, :slug, unique: true
  end
end
