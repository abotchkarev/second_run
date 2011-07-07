class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.integer :relationship_id
      t.integer :time_factor
      t.text :summary
      t.boolean :active, :default => true
      t.boolean :pause, :default => false

      t.timestamps
    end
    add_index :appointments, :relationship_id
    add_index :appointments, :active
  end

  def self.down
    drop_table :appointments
  end
end
