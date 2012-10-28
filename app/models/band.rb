class Band < ActiveRecord::Base
  has_many :user_bands
  has_many :users, through: :user_bands

  # age since last refresh used for data expiration
  EXPIRE_PERIOD = 1

  # retrieves the users top liked bands
  # if the last updated date of the bands is too old
  # it also queries facebook to refresh the data
  def self.retrieve_bands_for(user)
    bands = user.bands.limit(5).order('fan_count DESC')

    #bands that need refreshing
    refresh_count = bands.collect(&:needs_refresh?).size

    #if more than 3 bands require a refresh, refresh all the users bands
    if refresh_count > 3
      Rails.logger.info "data expired, refresh!"
      bands = FacebookBand.get_bands_for user
      bands.map{|b| b.save!}
      bands = bands.sort{|a, b| a.fan_count.to_i <=> b.fan_count.to_i}.to(4)
    end
    return bands
  end

  # retrieves details about the band
  # if it doesn't contain data from lastfm or the data is too old
  # it queries lastfm to refresh the data
  def self.get_band(page_id)
    band = where(:page_id => page_id).first
    return [] if band.blank?

    refresh_lastfm!

    save!
  end

  # checks to see if lastfm data is present on the record
  # or if it does, checks too see if it's too old then refreshes the data
  def needs_refresh?
    unless self.has_lastfm_data? || self.expired_data?
      self.refresh_lastfm!
    end
  end

  def refresh_lastfm!
    return unless needs_refresh?
    band = LastfmBand.find(data)
    self.listeners = band.listeners
    self.plays = self.plays
  end

  def refresh_facebook!
  end

  #checks to see if attributes from lastfm are populated
  def has_lastfm_data?
    attrs = [:listeners, :plays]
    attr_vals = []
    attrs.each do |attr|
      attr_vals << self.send(attr).present?
    end  
    attr_vals.all?
  end

  #checks if a records data is expired
  def expired_data?
    return updated_at < EXPIRE_PERIOD.minutes.ago
  end
  

end
