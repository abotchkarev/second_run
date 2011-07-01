class ChangeManagerInUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :manager, :boolean, :default => false
  end

  def self.down
    remove_column :users, :manager
  end
end
