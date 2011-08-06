class CreateTimeslots < ActiveRecord::Migration
  def self.up
    create_table :timeslots do |t|
      t.integer :appointment_id
      t.datetime :start_time 
      t.datetime :end_time
      t.integer :time_factor
    end
  end

  def self.down
    drop_table :timeslots
  end
end
