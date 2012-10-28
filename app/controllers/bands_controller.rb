class BandsController < ApplicationController
  before_filter :require_user
  respond_to :json


  # == Bands index
  # === Method: GET 
  # === Responds to +JSON+
  # === Request:
  #   * GET: http://api_path/bands
  # == Response:
  #   * [{\"fan_count\":'123131',\"id\":4,\"lastfm_url\":\"http://www.last.fm/music/Metallica\",\"listeners\":\"2232307\",\"mbid\":\"65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab\",\"name\":\"Metallica\",\"page_id\":\"10212595263\",\"pic_url\":null,\"plays\":\"201353582\"},{\"fan_count\":null,\"id\":5,\"lastfm_url\":\"http://www.last.fm/music/Charon\",\"listeners\":\"128141\",\"mbid\":\"12e9258a-ddc8-45be-a1bf-041ea37442bf\",\"name\":\"Charon\",\"page_id\":\"6826877886\",\"pic_url\":null,\"plays\":\"4381373\"}
  #
  #   === Errors:
  #   401 - Unauthorized request
  #   500 - System Error

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
  #  * {\"created_at\":\"2012-10-28T01:48:50Z\",\"fan_count\":14006104,\"id\":43,\"lastfm_name\":\"System of a Down\",\"lastfm_url\":null,\"listeners\":\"2949331\",\"mbid\":null,\"name\":\"System of a Down\",\"page_id\":\"16100944031\",\"pic_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/373050_16100944031_1083812154_s.jpg\",\"plays\":null,\"updated_at\":\"2012-10-28T01:49:46Z\"} 
  # === Errors:
  # 401 - Unauthorized request
  # 500 - System Error
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
  #  * [{"page_id"=>10901008068, "name"=>"Guns N' Roses", "band_members"=>"Axl Rose, Dj Ashba, Tommy Stinson, Dizzy Reed, Bumblefoot, Chris Pitman, Richard Fortus, Frank Ferrer ", "hometown"=>"Los Angeles, CA", "current_location"=>"Los Angeles, CA", "record_label"=>"Black Frog", "influences"=>"", "band_interests"=>"", "bio"=>"", "fan_count"=>18218368, "pic"=>"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/373044_10901008068_450276008_s.jpg"}}, { ... }]
  #   === Errors:
  #   401 - Unauthorized request
  #   404 - Band not found
  #   500 - System Error
  def related
    begin
      @band = Band.where(page_id: params[:id].to_s).first
      raise_soundpath_error(SoundpathError.new(SoundpathError::BAND_NOT_FOUND)) and return if @band.blank?

      @bands = Band.get_related_for @band.page_id, current_user
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
