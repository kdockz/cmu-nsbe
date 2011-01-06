class Registration < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :event
  
end
