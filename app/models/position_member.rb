class PositionMember < ActiveRecord::Base
  
  #Relationships
  belongs_to :position
  belongs_to :user
  
  #Other
  attr_accessible :position_id, :user_id
  
  # Scopes
  scope :by_position, lambda { |p| where('position_id = ?', p) } # named_scope :by_position, lambda { |p| { :conditions => ['position_id = ?', p] } }
  scope :current, where('active = ?', true) # named_scope :active, :conditions => ['active = ?', true]
  # named_scope :current, :conditions => ['start_year = ? OR end_year = ?', true]
  scope :eboard, where('position_members.active = ?', true)
  
    
  
end
