class Zone < ActiveRecord::Base
  
  #Relationships
  belongs_to :position
  
  #Other
  attr_accessible :name
  
end
