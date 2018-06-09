class CreatePerformers < ActiveRecord::Migration[5.2]
  def change
    create_table :performers do |t|
      t.integer :role, null: false
      t.belongs_to :character, foreign_key: true
      t.references :performable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
