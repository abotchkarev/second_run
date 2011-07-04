class AddSubordinationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :chief_id, :integer, :default => 1
    add_index :users, :chief_id

  end

  def self.down
    remove_column :users, :chief_id
  end
end
