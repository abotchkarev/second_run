class RemoveParentFromAppointment < ActiveRecord::Migration
  def self.up
    remove_column :appointments, :parent_id
  end

  def self.down
    add_column :appointments, :parent_id, :integer 
  end
end
