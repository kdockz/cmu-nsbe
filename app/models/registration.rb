class Registration < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :event
  
  scope :for_event, lambda { |e| where('event_id = ?', e) }
end
