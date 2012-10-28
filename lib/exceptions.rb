module Exceptions

  class LastfmError < StandardError

    def initialize(lastfm_response)
      @response = lastfm_response
    end

    def message
      err_msg = "LastFM API Error: #{@response['error']} -- #{@response['message']}"
    end
  end

end
