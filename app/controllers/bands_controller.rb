class BandsController < ApplicationController
  before_filter :require_user
  respond_to :json


  # == Bands index
  # === Method: GET 
  # === Responds to +JSON+
  # === Request:
  #   * GET: http://api_path/bands
  # == Response:
  #   * [{\"created_at\":\"2012-10-28T04:17:35Z\",\"fan_count\":27200606,\"id\":77,\"lastfm_name\":\"Metallica\",\"lastfm_url\":\"http://www.last.fm/music/Metallica\",\"listeners\":\"2232307\",\"mbid\":\"65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab\",\"name\":\"Metallica\",\"page_id\":\"10212595263\",\"pic_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/373044_10212595263_671351579_s.jpg\",\"plays\":\"201353582\",\"tags\":[\"thrash
  #   metal\",\"metal\",\"heavy metal\"],\"tracks\":[\"Enter Sandman\",\"Nothing Else Matters\",\"Master of Puppets\"],\"updated_at\":\"2012-10-28T05:01:23Z\"}]
  #
  #
  # === Errors:
  # * 401 - Unauthorized request
  # * 500 - System Error

  def index
    begin
      @bands = Band.retrieve_bands_for current_user
    rescue Fql::Exception => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::UNAUTHORIZED_REQUEST, ex.message))
      return
    rescue Exceptions::LastfmError => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::SYSTEM_ERROR), {:exception => ex})
      return
    end
    respond_with @bands
  end

  # == Bands show
  # === Method: GET
  # === Params:
  #   * band_id: The id of the band's facebook page
  # === Request:
  #   * GET http://api_path/band/:band_id
  # === Response
  #  * {\"created_at\":\"2012-10-28T04:17:35Z\",\"fan_count\":27200606,\"id\":77,\"lastfm_name\":\"Metallica\",\"lastfm_url\":\"http://www.last.fm/music/Metallica\",\"listeners\":\"2232307\",\"mbid\":\"65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab\",\"name\":\"Metallica\",\"page_id\":\"10212595263\",\"pic_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/373044_10212595263_671351579_s.jpg\",\"plays\":\"201353582\",\"tags\":[\"thrash
  #  metal\",\"metal\",\"heavy metal\"],\"tracks\":[\"Enter Sandman\",\"Nothing Else Matters\",\"Master of Puppets\"],\"updated_at\":\"2012-10-28T05:01:23Z\"}  
  #  === Errors:
  # * 401 - Unauthorized request
  # * 500 - System Error
  def show
    begin
      @band = Band.get_band(params[:id])
      raise_soundpath_error(SoundpathError.new(SoundpathError::BAND_NOT_FOUND)) and return if @band.blank?
    rescue Fql::Exception => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::UNAUTHORIZED_REQUEST, ex.message))
      return
    rescue Exceptions::LastfmError => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::SYSTEM_ERROR), {:exception => ex})
      return
    end

    respond_with @band
  end


  # == Bands related
  # ==== Retrieves related bands
  # === Method: GET
  # === Params:
  #   * band_id: The id of the band's facebook page
  # === Request:
  #   * GET http://api_path/band/:band_id/related
  # === Response
  #  * [{\"created_at\":\"2012-10-28T04:17:35Z\",\"fan_count\":27200606,\"id\":77,\"lastfm_name\":\"Metallica\",\"lastfm_url\":\"http://www.last.fm/music/Metallica\",\"listeners\":\"2232307\",\"mbid\":\"65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab\",\"name\":\"Metallica\",\"page_id\":\"10212595263\",\"pic_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/373044_10212595263_671351579_s.jpg\",\"plays\":\"201353582\",\"tags\":[\"thrash
  #  metal\",\"metal\",\"heavy metal\"],\"tracks\":[\"Enter Sandman\",\"Nothing Else Matters\",\"Master of Puppets\"],\"updated_at\":\"2012-10-28T05:01:23Z\"}, {...}]
  #
  #
  # === Errors:
  # * 401 - Unauthorized request
  # * 404 - Band not found
  # * 500 - System Error
  def related
    begin
      @band = Band.where(page_id: params[:id].to_s).first
      raise_soundpath_error(SoundpathError.new(SoundpathError::BAND_NOT_FOUND)) and return if @band.blank?

      @bands = Band.get_related_for @band, current_user
    rescue Fql::Exception => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::UNAUTHORIZED_REQUEST, ex.message))
      return
    rescue Exceptions::LastfmError => ex
      raise_soundpath_error(SoundpathError.new(SoundpathError::SYSTEM_ERROR), {:exception => ex})
      return
    end

    respond_with @bands
  end

end
