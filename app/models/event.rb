class Event < ActiveRecord::Base
  
  # Relationships
  has_many :registrations
  has_many :users, :through => :registrations
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  # Array
  STATUS = [['Upcoming', 0], ['Complete', 1]]
  

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
