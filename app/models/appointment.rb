# == Schema Information
# Schema version: 20110724005550
#
# Table name: appointments
#
#  id              :integer         not null, primary key
#  time_factor     :integer
#  summary         :text
#  active          :boolean         default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#  relationship_id :integer
#  pause           :boolean
#  start_time      :datetime
#  end_time        :datetime
#  parent_id       :integer
#

class Appointment < ActiveRecord::Base
  
  attr_accessible :relationship_id, :summary_time
  
  belongs_to :relationship
  belongs_to :project
  belongs_to :user
  
  validates :summary, :length => { :maximum => 150 }
  #  id              :integer         not null, primary key
  #  time_factor     :integer
  #  summary         :text
  #  active          :boolean         default(TRUE)
  #  created_at      :datetime
  #  updated_at      :datetime
  #  relationship_id :integer
  #  pause           :boolean

  def fork
    new = Appointment.new
    (self.attribute_names.delete_if {|attr| ["id", "created_at", "updated_at"].
          include?(attr)}).each {|f| new[f.to_sym] = self[f.to_sym]}
    return new
  end
  
  def save_inactive
    self.active = self.pause = false
    self.end_time = Time.now
    self.save
  end
  
  def save_inactive_child
    child = self.fork
    child.parent_id = self.id
    child.save_inactive
  end
  
  def save_paused
    self.pause = true
    self.start_time = nil
    self.time_factor = nil
    self.save
  end
  
  def save_running_with(time_factor)
    self.pause = false
    self.start_time = Time.now
    self.end_time = nil
    self.time_factor = time_factor
    self.save
  end
  
  def restart_with(time_factor)
    self.save_inactive_child
    self.save_running_with(time_factor)
  end
  
  def put_on_pause
    self.save_inactive_child
    self.save_paused
  end
end
