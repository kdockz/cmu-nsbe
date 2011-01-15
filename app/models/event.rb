class Event < ActiveRecord::Base
  
  # Relationships
  has_many :registrations
  has_many :users, :through => :registrations
  belongs_to :user
  
  # Array
  STATUS = [['Upcoming', 0], ['Ongoing', 1], ['Complete', 2]]
  
  attr_accessible :name, :location, :description, :registration, :capacity, :user_id, :start_date, :end_date, :start_time, :end_time
  
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

  # Methods
  def get_status
    unless self.status.nil? then 
      return STATUS[self.status][0]
    end
    "Unavailable"
  end
  
  def free_space?
    return true if Registration.for_event(id).size < capacity
    false
  end
  
  def available_slots 
    return capacity - Registration.for_event(id).size
  end
  
end
