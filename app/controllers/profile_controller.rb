class ProfileController < BaseController
  def index
    @user_total_btc = current_user.contributions.pluck(:btc_amount).sum
    @contributions_open = DateTime.now >= CONTRIB_OPEN_AT
    @early_contributions_open = DateTime.now >= EARLY_CONTRIB_OPEN_AT
  end

  def update
    current_user.update(profile_params)
    respond_to {|f| f.js }
  end

  def donation_history
    @user_total_btc = current_user.contributions.pluck(:btc_amount).sum
    @contributions = current_user.contributions.order('created_at DESC')
  end

  private
  def profile_params
    params.permit(:eth_address, :ark_address, :lisk_address, :shift_address, :raiblocks_address)
  end
end
