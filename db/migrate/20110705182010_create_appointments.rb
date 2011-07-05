class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :time_factor
      t.text :summary
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :appointments, :user_id
    add_index :appointments, :project_id
    add_index :appointments, :active
  end

  def self.down
    drop_table :appointments
  end
end
