class LastfmWorker

  def initialize(bands)
    @bands = bands
  end

  def work!
    @bands.each do |b|
      band_match = LastfmBand.search(b.name)
      next if band_match.blank?
      lastfm_data = LastfmBand.find(band_match['name'])
      puts lastfm_data['stats'].inspect
      band = Band.where(page_id: b.page_id).first
      band.lastfm_url = lastfm_data['url']
      band.mbid       = lastfm_data['mbid']
      band.plays      = lastfm_data['stats']['playcount']
      band.listeners  = lastfm_data['stats']['listeners']
      puts band.inspect
    end
  end

  def self.perform(bands)
    w = self.new(bands) 
    w.work!
  end
end
