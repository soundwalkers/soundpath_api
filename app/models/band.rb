class Band < ActiveRecord::Base
  has_many :user_bands
  has_many :users, through: :user_bands

  # age since last refresh used for data expiration
  EXPIRE_PERIOD = 1

  SCORE_WEIGHTS = [
    0.1, #likes
    0.2, #listeners
    0.1, #plays
    0.6, #fanbase
  ]

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

  # retrieves related bands for a specific band
  # updates facebook and lastfm data, computers score
  def self.get_related_for(band, user)
    related_bands = FacebookBand.related(band.page_id, user.token)
    bands = create_bands(related_bands, user)
    bands = Band.refresh_lastfm!(bands)

    bands.map{|b| b.update_score(band); }

    bands.map{|b| b.save!}
    bands = bands.sort{|a, b| b.score <=> a.score}.to(4)
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

  def top_tags
    (YAML::load(tags) || []) rescue []
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
    if band.tags.blank?
      self.tags = []
    else
      self.tags = band.tags
    end

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

  def fan_base_ratio
    100 - (plays.to_f / listeners.to_f)
  end

  def update_score(band)
    ref_tags = band.top_tags
    current_tags = self.tags

    if current_tags.blank? || current_tags.size == 0
      self.score = 0
    else
      self.score = (current_tags & ref_tags).size.to_f
    end

   #plays_i = plays.to_f
   #listeners_i = listeners.to_f
   #fan_count_i = fan_count.to_i
   #metrics = [fan_count_i, listeners_i, plays_i, (plays_i/listeners_i)]

   #sum = metrics.reduce(:+)
   #metrics = metrics.map{|m| m/sum}
   #band_score = 0
   #metrics.each_with_index do |m, idx|
   #  band_score += m * SCORE_WEIGHTS[idx]
   #end
   #self.score = band_score * 100
  end

end
