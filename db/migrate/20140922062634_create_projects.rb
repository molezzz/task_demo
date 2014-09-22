class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :key, null: false
      t.string :title, null: false
      t.belongs_to :team, index: true

      t.timestamps
    end
    add_index :projects, :key, unique: true
  end
end
