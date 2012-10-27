class User < ActiveRecord::Base
  has_many :user_bands
  has_many :bands, through: :user_bands

  attr_accessor :token
end
