class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  protected

  def authenticate_admin!
    return if current_user.admin?
    redirect_to(root_path)
  end
end
