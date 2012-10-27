class BandsController < ApplicationController
  before_filter :require_token
  respond_to :json


  # =Bands index
  # Method GET 
  # Responds to +JSON+
  # Request:
  #   GET: http://api_path/bands
  # Response:
  #   {'name': 'Metallica', 'fan_count': '131231', 'bio': 'band_bio'}

  def index
    @bands = Band.retrieve_bands_for current_user
    respond_with @bands
  end


end
