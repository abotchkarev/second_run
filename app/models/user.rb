require 'digest'

class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
    :confirmation => true,
    :length       => { :within => 6..40 }
  validates :name,  :presence   => true,
    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
    :format     => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
   
  before_save :encrypt_password
 
  
  has_one :subordination, :dependent => :destroy 
  accepts_nested_attributes_for :subordination
  attr_accessible :subordination_attributes
  
  has_one :chief, :through => :subordination 
    
  has_many :reverse_subordinations, :class_name => "Subordination",
    :foreign_key => "chief_id", :dependent => :destroy
   
  has_many :subordinates, :through => :reverse_subordinations, 
    :source => :subordinate

  has_many :projects, :dependent => :destroy


  has_many :relationships
  
  has_many :assignments, :class_name => "Project",
    :through => :relationships, :source => :project
  
  has_many :appointments, :through => :relationships
 
  #--------------------------------------------------------------------------

  def running_apps
    self.appointments.where(:active => true, :pause => false)
  end
  
  def active_apps
    self.appointments.where(:active => true)
  end

  def history(page)
    self.appointments.where(:active => false).
      paginate(:per_page => 5, :page => page, :order => 'end_time DESC')
  end
  
  def self.search(search, page)
    paginate(:per_page => 10, :page => page, 
      :conditions => ['name like ?', "%#{search}%"], 
      :order => 'name')
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt
  end
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #--------------------------------------------------------------------------

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

