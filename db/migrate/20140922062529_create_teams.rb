class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :key, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :teams, :key, unique: true
  end
end
