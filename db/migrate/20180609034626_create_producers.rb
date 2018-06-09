class CreateProducers < ActiveRecord::Migration[5.2]
  def change
    create_table :producers do |t|
      t.string :type
      t.belongs_to :anime, foreign_key: true
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
