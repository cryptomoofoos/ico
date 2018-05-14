class EarlyDonationsController < BaseController
  http_basic_authenticate_with name: INVESTOR_USER, password: INVESTOR_PWD, only: [:investors]

  def new
    @currency = params[:currency]
    @currency_to_usd = LWF.send("#{@currency}_to_usd")
    @precision = 7 if @currency == 'btc'
    @precision = 5 if @currency == 'eth'
    @precision ||= 2

    @user_total_btc = current_user.contributions.pluck(:btc_amount).sum

    @early_contributions_open = DateTime.now >= EARLY_CONTRIB_OPEN_AT
  end

  def create
    raise 'amount required' if params[:amount].blank?

    ActiveRecord::Base.transaction do
      @currency = params[:currency]
      @precision = 7 if @currency == 'btc'
      @precision = 5 if @currency == 'eth'
      @precision ||= 2

      if @currency == 'btc'
        current_user.assign_btc_address!
      elsif @currency == 'eth'
        current_user.assign_eth_address!
      elsif @currency == 'zcoin'
        @zcoin_address = current_user.assign_zcoin_address!
      elsif @currency == 'pivx'
        @pivx_address = current_user.assign_pivx_address!
      elsif @currency == 'reddcoin'
        @reddcoin_address = current_user.assign_reddcoin_address!
      else
        current_user.update!(address_params)
      end

      @redirect = profile_path
    end

    SiteMailer.donation(current_user, @currency, params[:amount]).deliver_now

    respond_to {|f| f.js }
  end

  def investors
    current_user.contribution_bonus ||= INVESTOR_BONUS
    current_user.save!
    redirect_to(profile_path)
  end

  private
  def address_params
    params.permit(:ark_address, :lisk_address, :shift_address, :oxy_address)
  end
end
