class Position < ActiveRecord::Base
  
  # Relationships
  has_one :zone
  belongs_to :zone
  has_many :position_members
  has_many :users, :through => :position_members
  
  # Other
  attr_accessible :name, :zone_id, :email, :description
  
  # Scopes
  scope :by_zone, lambda { |z| where('zone_id = ?', z) } # named_scope :by_zone, lambda { |z| { :conditions => ['zone_id = ?', z] } }
  # scope :current, where('active = ?', true).order("zone_id")
  scope :eboard, joins('left outer join position_members on positions.id=position_members.position_id').where('position_members.position_id is null')
end
