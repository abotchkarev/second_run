class RemoveManagerFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :manager
    remove_column :users, :chief_id
  end

  def self.down
    add_column :users, :manager, :boolean
    add_column :users, :chief_id, :integer
  end
end
