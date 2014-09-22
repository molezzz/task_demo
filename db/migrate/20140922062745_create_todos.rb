class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :key, null: false
      t.belongs_to :project, index: true
      t.integer :creator_id
      t.integer :owner_id
      t.text :content
      t.datetime :end_at
      t.datetime :complate_at

      t.timestamps
    end
    add_index :todos, :key, unique: true
    add_index :todos, :creator_id
    add_index :todos, :owner_id
  end
end
