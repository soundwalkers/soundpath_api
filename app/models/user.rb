class User < ActiveRecord::Base
  has_many :user_bands
  has_many :bands, through: :user_bands

  attr_accessor :token

  # gets the calling user or creates a new one if it doesn't exist,
  # based on it's facebook uir
  def self.get_user(uid, token)
    u = User.where(facebook_id: uid).first_or_initialize
    u.token = token
    u.save!
    return u
  end
end
