class LastfmBand 
  def self.search(band_name)
    band_name = URI::escape(band_name)
    query="http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    #execute(query)['results']['artistmatches']['artist'].first
    artist = execute(query)['results']['artistmatches']['artist']
    if artist.is_a? Array
      return artist.first
    elsif artist.is_a? Hash
      return artist
    end
  end

  def self.find(band_name)
    band_name = URI::escape(band_name)
    query = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    execute(query)['artist']
  end

  def self.execute(query)
    result = RestClient.get query
    JSON.parse result
  end
end
