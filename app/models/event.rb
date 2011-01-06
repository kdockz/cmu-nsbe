class Event < ActiveRecord::Base
  
  # Relationships
  has_many :registrations
  has_many :users, :through => :registrations

end
