class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :suspended?

  protected
  def suspended?
    return unless (current_user.present? && current_user.suspended?)
    sign_out current_user
    flash[:error] = "Your account has been disabled"
    root_path
  end
end
