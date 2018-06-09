class CreateStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :staffs do |t|
      t.string :role, null: false
      t.belongs_to :anime, foreign_key: true
      t.belongs_to :person, foreign_key: true

      t.timestamps
    end
  end
end
