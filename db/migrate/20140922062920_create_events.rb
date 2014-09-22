class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :kind
      t.integer :source_id
      t.string :target
      t.integer :target_id
      t.text :data

      t.timestamps
    end
    add_index :events, :source_id
    add_index :events, [:target,:target_id]
  end
end
