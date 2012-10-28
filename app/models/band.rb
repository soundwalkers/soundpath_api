class Band < ActiveRecord::Base
  has_many :user_bands
  has_many :users, through: :user_bands

  # age since last refresh used for data expiration
  EXPIRE_PERIOD = 1

  # multi threaded refreshing of last fm data for the bands
  def self.refresh_lastfm!(bands)
    threads = []
    bands.each do |band|
      threads << Thread.new do
        band.refresh_lastfm!
      end
    end
    threads.map{|t| t.join}
    bands
  end

  # retrieves the users top liked bands
  # if the last updated date of the bands is too old
  # it also queries facebook to refresh the data
  def self.retrieve_bands_for(user)

    user_bands = FacebookBand.all user.facebook_id, user.token
    bands = create_bands(user_bands, user)
    bands = Band.refresh_lastfm!(bands)
    bands.map{|b| b.save!}
    bands = bands.sort{|b, a| a.fan_count.to_i <=> b.fan_count.to_i}.to(4)

    return bands
  end

  def self.get_related_for(page_id, user)
    related_bands = FacebookBand.related(page_id, user.token)
    bands = create_bands(related_bands, user)
    bands = Band.refresh_lastfm!(bands)
    bands.map{|b| b.save!}
    bands = bands.sort{|b, a| a.fan_count.to_i <=> b.fan_count.to_i}.to(4)
  end

  # retrieves details about the band
  # if it doesn't contain data from lastfm or the data is too old
  # it queries lastfm to refresh the data
  def self.get_band(page_id)
    band = where(:page_id => page_id).first
    return [] if band.blank?

    band.refresh_lastfm!

    band.save!
    band
  end

  def self.create_bands(fb_bands, user)
    bands = []
    fb_bands.each do |b|
      band = Band.where(:page_id => b.page_id.to_s).first_or_initialize
      band.name = b.name
      band.fan_count = b.fan_count.to_s
      band.pic_url = b.pic
      band.users << user
      bands << band
    end
    bands
  end

  # checks to see if lastfm data is present on the record
  # or if it does, checks too see if it's too old then refreshes the data
  def needs_refresh?
    !self.has_lastfm_data? || self.expired_data?
  end

  def refresh_lastfm!
    #return unless needs_refresh?

    include_search = self.lastfm_name.blank?

    band = LastfmBand.find(self.name_for_lastfm, include_search)

    return if band.blank?
    self.listeners = band.listeners
    self.plays = band.plays
    self.lastfm_name = band.name
    self.lastfm_url = band.url
    self.mbid = band.mbid
    self.tracks = band.tracks
    self.tags = band.tags
  end

  # checks to see if attributes from lastfm are populated
  def has_lastfm_data?
    attrs = [:listeners, :plays]
    attr_vals = []
    attrs.each do |attr|
      attr_vals << self.send(attr).present?
    end  
    attr_vals.all?
  end

  # checks if a records data is expired
  def expired_data?
    updated_at < EXPIRE_PERIOD.minutes.ago
  end
  
  # convenience method for retrieving the band name
  def name_for_lastfm
    if self.lastfm_name.present?
      self.lastfm_name
    else
      self.name
    end
  end
  

end
