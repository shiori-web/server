class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.belongs_to :person, foreign_key: true
      t.belongs_to :manga, foreign_key: true
    end
  end
end
