class RemoveManagerFromSubordinations < ActiveRecord::Migration
  def self.up
    remove_column :subordinations, :manager
  end

  def self.down
    add_column :subordinations, :manager, :boolean
  end
end
