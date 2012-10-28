# FQL wrapper class with ActiveRecord-like convenience methods
class FacebookBand
  attr_accessor :data

  # returns all liked artist pages for a user
  def self.all(api_token)
    query = "SELECT #{band_attributes.join(',')} FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE uid=me() AND type=\"Musician/band\") ORDER BY fan_count DESC"
    execute(query, api_token).map{|r| new(r)}
  end

  # find a page by it's id
  def self.find(api_token, band_id)
    query = "SELECT #{band_attributes.join(',')} FROM page WHERE page_id = #{band_id}"
    execute(query, api_token)
  end

  # execute the query
  def self.execute(query, api_token)
    Rails.logger.info "Executing Fql: #{query}"
    Fql.execute(query, {:access_token => api_token})
  end

  # attributes of interest for a band
  def self.band_attributes
    ["page_id", "name", "band_members", "hometown", "current_location", "record_label", "influences", "band_interests", "bio", "fan_count", "pic"]
  end


  # retrieve and update/save bands for a user
  def self.get_bands_for(user)
    fbands = all user.token
    bands = []
    fbands.each do |b|
      band = Band.where(:page_id => b.page_id.to_s).first_or_initialize
      band.name = b.name
      band.fan_count = b.fan_count.to_s
      band.pic_url = b.pic
      band.users << user
      bands << band
    end
    return bands
  end

  # define methods to conveniently access attributes
  self.band_attributes.each do |attr|
    define_method attr do
      @data[attr]
    end
  end

  def initialize(fb_data)
    @data = fb_data
  end

end
