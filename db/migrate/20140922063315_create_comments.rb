class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :key, null: false
      t.belongs_to :user, index: true
      t.belongs_to :todo, index: true
      t.text :content

      t.timestamps
    end
    add_index :comments, :key, unique: true
  end
end
