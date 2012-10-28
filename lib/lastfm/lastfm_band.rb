class LastfmBand 
  attr_accessor :data

  #wrapper method for lastfm search api call
  # params: 
  # -band_nane
  def self.search(band_name)
    band_name = URI::escape(band_name)
    query="http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    result = execute(query)
    artist = result['results']['artistmatches']['artist']
    if artist.is_a? Array
      return artist.first
    elsif artist.is_a? Hash
      return artist
    end
  end

  # wrapper method for lastfm getInfo methid
  # params:
  #   -last fm band as it is on lastfm
  def self.find(band_name)
    band_name = URI::escape(band_name)
    query = "http://ws.audioscrobbler.com/2.0/?method=artist.getInfo&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    execute(query)['artist']
  end


  #method that executes the actual query
  #param:
  # -the query to be executed
  def self.execute(query)
    result = RestClient.get query
    parsed_result = JSON.parse result
    raise Exceptions::LastfmError.new(parsed_result) if parsed_result.has_key?('error')
    return parsed_result
  end

  def self.get_info_for(bands)
    LastfmWorker.perform(bands)
  end

  def initialize(lastfm_data)
    @data = data
  end

  def listeners
    data['stats']['listeners']
  end

  def name
    data['name']
  end

  def plays
    data['playcount']
  end

  def url
    data['url']
  end

  def mbid
    data['mbid']
  end

end
