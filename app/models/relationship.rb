class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  # only who is being followed by you is editable
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
  
end