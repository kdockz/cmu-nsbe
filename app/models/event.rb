class Event < ActiveRecord::Base
  
  attr_accessible :name, :location, :description, :registration, :capacity, :user_id, :start_date, :end_date, :start_time, :end_time
  
  # Relationships
  has_many :registrations
  has_many :users, :through => :registrations
  belongs_to :user
  
  # Array
  STATUS = [['Upcoming', 0], ['Ongoing', 1], ['Complete', 2]]
    
  # Validations
  validates :name, :presence => true
  validates :location, :presence => true
  validates :description, :presence => true
  validates :registration, :inclusion => { :in => [true, false] }
  validates :user_id, :presence => true, :inclusion => { :in => User.all.map{ |u| u.id } }
  
  # Scopes
  scope :upcoming, where('start_date > ?', Date.today)
  scope :ongoing, where('status = ?', 1)
  scope :completed, where('status = ?', 2)
  scope :today, where('start_date = ?', Date.today)
  scope :past, where('end_date < ?', Date.today)
  scope :events_being_planned, where('end_date = ? and start_date = ? and end_time = ? and start_time = ?', nil, nil, nil, nil)

  # Methods
  
  # Returns status of the event, and unavailable when it is not set.
  def get_status
    unless self.status.nil? then 
      return STATUS[self.status][0]
    end
    "Unavailable"
  end
  
  # Determines whether there is any space left for an event that has a capacity.
  def free_space?
    return true if !capacity.nil? && Registration.for_event(id).size < capacity
    return true if capacity.nil? && registration == true
    false
  end
  
  # Decides whether an event is public or not, based on if capacity is nil and registration is false.
  def public?
    return true if self.capacity.nil? && self.registration == false
    false
  end
  
  # Returns the number of available spots left for an event, given that it has a capacity.
  def available_slots 
    return capacity - Registration.for_event(id).size
  end
  
  # Checks to make sure all date fields, and time fields are set, in order to create a google event.
  def check_date_and_time
    if (!self.start_date.nil? && !self.start_time.nil? && !self.end_date.nil? && !self.end_time.nil?)
      return true
    elsif (self.start_date.nil? || self.start_time.nil? || self.end_date.nil? || self.end_time.nil?)
      return false
    else 
      return false
    end
  end
end
