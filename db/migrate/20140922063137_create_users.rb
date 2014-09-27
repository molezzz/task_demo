class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :key, null: false
      t.belongs_to :team, index: true
      t.string :name
      t.string :email
      t.text :avatar
      t.string :password
      t.string :salt

      t.timestamps
    end
    add_index :users, :key, unique: true
    add_index :users, :email, unique: true
  end
end
