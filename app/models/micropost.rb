class Micropost < ActiveRecord::Base
  
  attr_accessor :in_reply_to
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true 
    
  default_scope :order => 'microposts.created_at DESC'
  
  # Return microposts from the users being followed by the given user
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  # Return microposts addressed to the user
  scope :including_replies, where(:in_reply_to => :user_id)
  
  
  private
  
  # Return an SQL condition for users followed by the given user.
  # We include the uder's own id as well. CHANGE THIS TO AREL
  
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id)
    where("user_id IN (#{following_ids}) OR user_id = :user_id",
          { :user_id => user })
  end
  
  #def self.addressed_to(user)
  #  addressed_ids = Micropost.select()
  #end

  # This might involve adding an in_reply_to column in
  # the microposts table and an extra including_replies
  # scope to the Micropost model.
  
  
  
  
end

