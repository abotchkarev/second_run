class CreateSubordinations < ActiveRecord::Migration
  def self.up
    create_table :subordinations do |t|
      t.integer :user_id
      t.integer :chief_id
      t.boolean :manager

      t.timestamps
    end
    add_index :subordinations, :user_id
    add_index :subordinations, :chief_id
    add_index :subordinations, [:user_id, :chief_id], :unique => true

  end

  def self.down
    drop_table :subordinations
  end
end
