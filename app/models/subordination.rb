# == Schema Information
# Schema version: 20110726002154
#
# Table name: subordinations
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  chief_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subordination < ActiveRecord::Base
  
  attr_accessible :user_id, :chief_id
  validates :chief_id, :presence => true
  
  belongs_to :chief, :class_name => "User"
  belongs_to :subordinate, :class_name => "User", :foreign_key => "user_id"
  
end
