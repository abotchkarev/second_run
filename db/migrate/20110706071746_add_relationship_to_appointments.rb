class AddRelationshipToAppointments < ActiveRecord::Migration
  def self.up
    add_column :appointments, :relationship_id, :integer
    add_column :appointments, :pause, :boolean, :default => false
    remove_column :appointments, :user_id
    remove_column :appointments, :project_id
    add_index :appointments, :relationship_id
  end

  def self.down
    remove_column :appointments, :relationship_id
    remove_column :appointments, :pause
    add_column :appointments, :user_id
    add_column :appointments, :project_id
  end
end
