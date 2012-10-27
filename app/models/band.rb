class Band < ActiveRecord::Base
  has_many :user_bands
  has_many :users, through: :user_bands

  def self.retrieve_bands_for(user)
    fbands = FacebookBand.all user.token
    fbands.each do |b|
      band = Band.where(:page_id => b['page_id'].to_s).first_or_initialize
      band.name = b['name']
      band.fan_count = b['fan_count'].to_s
      band.users << user
      band.save
    end
  end
end
