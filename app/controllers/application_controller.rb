class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # if Rails.env.production?
  #   http_basic_authenticate_with name: "lwf", password: "Lwf2017"
  # end

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_referral

  protected
  def set_referral
    return if params[:ref].blank?
    session[:referred_by] = params[:ref]
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || profile_path
  end

  def configure_permitted_parameters
    attrs = %i[username email first_name last_name password password_confirmation referred_by remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: attrs
    # devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
