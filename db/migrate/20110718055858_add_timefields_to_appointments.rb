class AddTimefieldsToAppointments < ActiveRecord::Migration
  def self.up
    add_column :appointments, :start_time, :datetime
    add_column :appointments, :end_time, :datetime
    add_index :appointments, :start_time
    add_index :appointments, :end_time
  end

  def self.down
    remove_column :appointments, :end_time
    remove_column :appointments, :start_time
  end
end
