class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
