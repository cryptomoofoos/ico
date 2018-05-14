class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: [:index]

  def index
    @users = User.order('username ASC')
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save
      return redirect_to(admin_users_path, notice: 'User updated')
    end
    render :edit
  end

  def suspend
    @user.suspended = ! @user.suspended
    @user.save
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :contribution_bonus)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
