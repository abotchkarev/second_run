# == Schema Information
# Schema version: 20110727012528
#
# Table name: timeslots
#
#  id             :integer         not null, primary key
#  appointment_id :integer
#  start_time     :datetime
#  end_time       :datetime
#  time_factor    :integer
#

class Timeslot < ActiveRecord::Base
  
  belongs_to :appointment
  
end
