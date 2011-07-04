# == Schema Information
# Schema version: 20110704005555
#
# Table name: subordinations
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  chief_id   :integer
#  manager    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Subordination < ActiveRecord::Base
   attr_accessible :user_id, :chief_id

  belongs_to :user
end
