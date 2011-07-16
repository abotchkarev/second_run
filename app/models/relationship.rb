# == Schema Information
# Schema version: 20110704075232
#
# Table name: relationships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Relationship < ActiveRecord::Base
  
  attr_accessible :user_id, :project_id

  belongs_to :project
  belongs_to :user
  accepts_nested_attributes_for :project
  
  has_many :appointments

 # validates :user_id, :presence => true
 # validates :project_id, :presence => true


end
