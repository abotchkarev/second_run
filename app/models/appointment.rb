# == Schema Information
# Schema version: 20110706071746
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
#

class Appointment < ActiveRecord::Base
  attr_accessible :relationship_id, :time_factor,
    :summary, :active, :pause
  
  belongs_to :relationship
  
  validates :summary, :length => { :maximum => 150 }
end
