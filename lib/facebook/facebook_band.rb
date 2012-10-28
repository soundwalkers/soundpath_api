class FacebookBand
  def self.all(api_token)
    query = "SELECT #{band_attributes[:select]} FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE uid=me() AND type=\"Musician/band\") ORDER BY fan_count DESC"
    return execute(query, api_token)
  end

  def self.execute(query, api_token)
    Fql.execute(query, {:access_token => api_token})
  end

  def self.band_attributes
    {:select => "page_id, name, band_members, hometown, current_location, record_label, influences, band_interests, bio, fan_count"}
  end

  def self.get_bands_for(user)
    fbands = all user.token
    bands = []
    fbands.each do |b|
      band = Band.where(:page_id => b['page_id'].to_s).first_or_initialize
      band.name = b['name']
      band.fan_count = b['fan_count'].to_s
      band.pic_url = b['pic']
      band.users << user
      bands << band
    end
    return bands
  end
end
