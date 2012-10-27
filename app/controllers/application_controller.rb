class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_token #dev hack

  def add_token
    params[:token] = "AAACEdEose0cBAIoYZAxLvJbmcEOAQ1FVzh3nWpN7J5VtZC0G747lNzeRo4SEjl3uKLfwkZBIcflTfZAmGHROPDPGoftouPgEMj5TDH5QDNZAhrlBr3ZB4b"
  end

  def current_user
    u = User.first
    u.token = "AAACEdEose0cBAJLcHygfUal3Wdqjphb0SKjm7DN3VRMiNMOqpOehuBBMGO2shQ6vHD7LDPDY9OpqTEjZCGYt98vlaQZCjsZBIO6UElZACJy0X3IVfFQb"
    return u
  end


  def require_token
    raise_api_error(SoundpathError.new(SoundpathError::UNAUTHORIZED_REQUEST ))  unless current_user.token.present?
  end

  def raise_api_error(error, log_message = "")
    Rails.logger.error log_message if log_message.present?
    msg = {:message => error.message, :status => error.status}
    respond_with msg
  end
end
