class LastfmWorker

  def initialize(bands)
    @bands = bands
  end

  def work!
    @bands.each do |b|
      band_match = LastfmBand.search(b.name)
      Rails.logger.info band_match.inspect
      next if band_match.blank?
      lastfm_band = LastfmBand.find(band_match['name'])
      b.lastfm_url   = lastfm_band.url
      b.mbid         = lastfm_band.mbid
      b.plays        = lastfm_band.plays
      b.listeners    = lastfm_band.listeners
      b.lastfm_name  = lastfm_band.name
    end
    @bands
  end

  def self.perform(bands)
    w = self.new(bands) 
    w.work!
  end
end
