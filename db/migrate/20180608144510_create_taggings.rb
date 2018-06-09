class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, foreign_key: true
      t.references :taggable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
