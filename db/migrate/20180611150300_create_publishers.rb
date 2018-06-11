class CreatePublishers < ActiveRecord::Migration[5.2]
  def change
    create_table :publishers do |t|
      t.belongs_to :manga, foreign_key: true
      t.belongs_to :producer, foreign_key: true
    end
  end
end
