class CreateProducers < ActiveRecord::Migration[5.2]
  def change
    create_table :producers do |t|
      t.string :name, null: false
      t.hstore :info

      t.timestamps
    end
  end
end
