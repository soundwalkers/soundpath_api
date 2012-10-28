class LastfmBand 
  attr_accessor :data

  # === Wrapper method for lastfm search api call
  # === Params: 
  # -band_nane
  def self.search(band_name)
    band_name = URI::escape(band_name)
    query="http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    result = execute(query)
    artist = result['results']['artistmatches']['artist']


    if artist.is_a? Array
      d = artist.first
    elsif artist.is_a? Hash
      d = artist
    end
    
    if d.present?
      return new(d)
    else
      return nil
    end
  end

  # ==== Wrapper method for lastfm getInfo methid
  # === params:
  #   -last fm band as it is on lastfm
  def self.find(band_name, include_search = false)
    if include_search
      band_name = URI::escape(self.search(band_name).name)
    else
      band_name = URI::escape(band_name)
    end
    query = "http://ws.audioscrobbler.com/2.0/?method=artist.getInfo&artist=#{band_name}&api_key=#{$LAST_FM_API_KEY}&format=json"
    return new(execute(query)['artist'])
  end


  # === Method that executes the actual query
  # ===params:
  # -the query to be executed
  def self.execute(query)
    Rails.logger.info "Executing LastFM query: #{query}"
    result = RestClient.get query
    parsed_result = JSON.parse result
    raise Exceptions::LastfmError.new(parsed_result) if parsed_result.has_key?('error')
    return parsed_result
  end

  # === Retrives lastfm info for bands
  # === Params:
  # * array containing band names
  def self.get_info_for(bands)
    LastfmWorker.perform(bands)
  end

  def initialize(lastfm_data)
    @data = lastfm_data
  end

  def listeners
    data['stats']['listeners']
  end

  def name
    data['name']
  end

  def plays
    data['stats']['playcount']
  end

  def url
    data['url']
  end

  def mbid
    data['mbid']
  end

end
