class Admin::ContributionsController < Admin::BaseController
  before_action :set_contrib, except: [:index, :new, :create]
  before_action :set_users, only: [:new, :create]

  def index
    @contribs = Contribution.order('created_at DESC')
    @total_btc = @contribs.sum(:btc_amount_no_bonus)
    @total_btc_bonus = @contribs.sum(:btc_amount)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def new
    @contrib = Contribution.new
  end

  def create
    @contrib = Contribution.new(contrib_params)
    if @contrib.save
      return redirect_to(admin_contributions_path, notice: 'Contribution created')
    end
    render :new
  end

  def edit
  end

  def update
    @contrib.assign_attributes(contrib_params)
    if @contrib.save
      return redirect_to(admin_contributions_path, notice: 'Contribution updated')
    end
    render :edit
  end

  def destroy
    @contrib.destroy
    redirect_to(admin_contributions_path, notice: 'Contribution deleted')
  end

  private
  def contrib_params
    params.require(:contribution).permit(:user_id, :currency, :amount, :tx_hash, :sender, :bonus_pct, :bonus_per_btc, :bypass_bonus_limit)
  end

  def set_contrib
    @contrib = Contribution.find(params[:id])
  end

  def set_users
    @users = User.order('username ASC').select(:id, :username)
  end
end
