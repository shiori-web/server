class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :username, null: false
      t.string :confirm_token
      t.boolean :confirmed, default: false
      t.string :encrypted_password, null: false

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :confirm_token, unique: true
  end
end
