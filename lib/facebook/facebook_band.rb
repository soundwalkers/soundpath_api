class FacebookBand
  def self.all(api_token)
    query = "SELECT #{band_attributes[:select]} FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE uid=me() AND type=\"Musician/band\") ORDER BY fan_count DESC"
    return execute(query, api_token)
  end

  def self.execute(query, api_token)
    return Fql.execute(query, {:access_token => api_token})
  end

  def self.band_attributes
    {:select => "page_id, name, band_members, hometown, current_location, record_label, influences, band_interests, bio"}
  end
end
