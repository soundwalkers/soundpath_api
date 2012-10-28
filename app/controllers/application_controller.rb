class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_token #dev hack

  def add_token
    if params[:token].blank?
      params[:token] = "BAAGm65u5qXgBAJ0RZCiIIKbOyaZApEKfYotSGaXrw03HZB09EP7KykNC8Wt7Puz1XJex5SDRtgH62TBZC7fzdbFfYBzibWRwjT6Uvlx4YmKCIs7CWHdh2ig6TALdqgXKPHSc3MTvNQZDZD"
    end
      params[:uid] = '1274334424'
  end

  def current_user
    u = User.where(:facebook_id => params[:uid]).first
    return nil if u.blank?
    u.token = params[:token]
    return u
  end


  def require_user
    raise_soundpath_error(SoundpathError.new(SoundpathError::UNAUTHORIZED_REQUEST ))  unless current_user.present?
  end

  def raise_soundpath_error(error, options = {})
    Rails.logger.error log_message if options[:log_message].present?
    if options[:exception].present?
      Rails.logger.error options[:exception].message
    end
    msg = {:message => error.message, :status => error.status}
    respond_with msg
  end
end
