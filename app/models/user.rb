require 'digest/sha1'

class User < ActiveRecord::Base
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  

  set_table_name 'users'
  
  #Relationships 
  has_many :position_members
  has_many :positions, :through => :position_members
  has_many :registrations
  has_many :events, :through => :registrations
  has_attached_file :photo, :styles => { :medium => "100x100>", :thumb => "50x50>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml"
  
  # Note - User levels will be defined as follows:
  # 10 - NSBE Chapter and/or National Member
  # 30 - NSBE Executive Board
  # 50 - Site Administrator (Should be person(s) in charge of managing the site, as well as the chapter president. Other administrators will be appointed as current administrators see fit.)
  
  # Arrays
  MAJORS = [["Biological Sciences", 0], ["Business", 1], ["Chemical Engineering", 2], ["Chemistry", 3], ["CIT--Undeclared", 4], ["Civil & Environmental Engineering", 5], ["Computer Science", 6], ["Electrical & Computer Engineering", 7], ["Information Systems Management", 8], ["Information Systems", 9], ["Material Science & Engineering", 10], ["Mathematical Sciences", 11], ["Mechanical Engineering", 12], ["Physics", 13], ["Policy & Management", 14], ["Other", 15], ["Undecided", 16]] 
   CLASS_LEVELS = [['Freshman', 0], ['Sophomore', 1], ['Junior', 2], ['Senior', 3], ['Graduate', 4], ['Alumni', 5]]
     
  # Validations
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
  # validates_attachment_size :photo, :less_than=>2.megabyte
  # validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
  validates_presence_of :first_name, :last_name, :class_level, :major
  validates_inclusion_of :class_level, :in => CLASS_LEVELS.map{|key, value| value }
  validates_inclusion_of :major, :in => MAJORS.map{|key, value| value }

  # Scopes

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :first_name, :last_name, :password, :password_confirmation, :class_level, :major, :phone_number, :active, :photo
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  
  # Methods
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
  
  def get_biography
    unless self.biography.nil? || self.biography.empty? then
      return biography
    end
    "#{self.first_name} has not set their biography."
  end
  
  def admin_or_eboard?
    if access_level >= 30 then
      return true
    else
      return false
    end
  end
  
  def admin?
    if access_level == 50 then
      return true
    else
     return false
   end
  end

  def eboard_member?
    if access_level == 30 then
      return true
    else
      return false
    end
  end
  protected



end
