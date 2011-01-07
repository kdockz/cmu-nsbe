require 'digest/sha1'

class User < ActiveRecord::Base

  #Relationships 
  has_many :position_members
  has_many :positions, :through => :position_members
  has_many :registrations
  has_many :events, :through => :registrations
  has_attached_file :photo, :styles => { :medium => "100x100>", :thumb => "50x50>" }
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  set_table_name 'users'

  validates :login, :presence   => true,
  :uniqueness => true,
  :length     => { :within => 3..40 },
  :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :first_name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
  :length     => { :maximum => 100 },
  :allow_nil  => true


  validates :last_name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
  :length     => { :maximum => 100 },
  :allow_nil  => true

  validates :email, :presence   => true,
  :uniqueness => true,
  :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
  :length     => { :within => 6..100 }
  
  # validates_attachment_presence :photo                    
  #  validates_attachment_size :photo, :less_than=>2.megabyte
  #  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
 


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :first_name, :last_name, :password, :password_confirmation, :class_level, :major, :phone_number, :active, :photo
  
  MAJORS = [ ["Biological Science", 0], ["Business", 1], ["Chemical Engineering", 2], ["Chemistry", 3], ["CIT--Undeclared", 4], ["Civil Engineering", 5], ["Computer Science", 6], ["Electrical & Computer Engineering", 7], ["Information Systems Management", 8], ["Information Systems", 9], ["Material Science Engineering", 10], ["Mathematical Science", 11], ["Mechanical Engineering", 12], ["Physics", 13], ["Policy & Management", 14], ["Other", 15] ] 
   CLASS_LEVELS = [['Freshman', 0], ['Sophomore', 1], ['Junior', 2], ['Senior', 3], ['Graduate']]

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def nice_name
    "#{self.first_name} #{self.last_name}"
  end
  def get_major
    unless self.major.nil? then 
      return MAJORS[self.major][0]
    end
    "Unavailable"
  end
  def get_class
    unless self.class_level.nil? then 
      return CLASS_LEVELS[self.class_level][0]
    end
    "Unavailable"
  end

  protected



end
