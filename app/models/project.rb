# == Schema Information
# Schema version: 20110701005536
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  
  attr_accessible :title, :description, :user_id
  validates :user_id, :presence => true
  validates :title, :presence => true, :length => { :maximum => 140 }
  default_scope :order => 'projects.created_at DESC'

  belongs_to :user
  
  has_many :relationships, :dependent => :destroy
  accepts_nested_attributes_for :relationships, :allow_destroy => true
  attr_accessible :relationships_attributes
  validates_associated :relationships
 
  has_many :appointments, :through => :relationships
  
  has_many :executors, :class_name => "User",
    :through => :relationships, :source => :user
  

  

  
  

  


  #--------------------------------------------------------------
   
  #def progress
  #  appointments
  #end
  
  #def progress_by(user)
  #  relationships.find_by_user_id(user).appointments
  #end
end

