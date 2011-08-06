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
#  parent_id       :integer    # ?????
#

class Appointment < ActiveRecord::Base
  
  attr_accessible :relationship_id, :summary
  
  belongs_to :relationship
  belongs_to :project
  belongs_to :user
  
  validates :summary, :length => { :maximum => 150 }
  
  has_many :timeslots, :dependent => :destroy

  def fork
    timeslot = self.timeslots.build
    timeslot.start_time = self.start_time
    timeslot.end_time = self.end_time
    timeslot.time_factor = self.time_factor
    return timeslot
  end
 
  def save_running_with(time_factor)
    self.pause = false
    self.start_time = Time.now
    self.end_time = nil
    self.time_factor = time_factor
    self.save
  end
  
  def save_paused
    self.pause = true
    self.start_time = nil
    self.time_factor = nil
    self.save
  end
  
  def save_inactive
    self.active = self.pause = false
    self.start_time = self.created_at
    self.end_time = Time.now
    self.time_factor = 1
    self.save
  end
  
  def save_inactive_child
    child = self.fork
    child.end_time = Time.now
    child.save
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
