class AddParentToAppointments < ActiveRecord::Migration
  def self.up
    add_column :appointments, :parent_id, :integer
    add_index :appointments, :parent_id
  end

  def self.down
    remove_column :appointments, :parent_id
  end
end
