class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.belongs_to :genre, foreign_key: true
      t.references :categorizable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
