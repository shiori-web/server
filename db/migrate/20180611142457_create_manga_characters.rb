class CreateMangaCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :manga_characters do |t|
      t.integer :role, null: false
      t.belongs_to :manga, foreign_key: true
      t.belongs_to :character, foreign_key: true

      t.timestamps
    end
  end
end
