class AddRelationshipToAppointments < ActiveRecord::Migration
  def self.up
    remove_column :appointments, :user_id
    remove_column :appointments, :project_id
  end

  def self.down
    add_column :appointments, :user_id
    add_column :appointments, :project_id
  end
end
