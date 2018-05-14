class SiteController < BaseController
  before_action :authenticate_user!, only: [:refund]

  def index
    @btc_total = Contribution.btc.sum(:amount)
    @eth_total = Contribution.eth.sum(:amount)
    @ark_total = Contribution.ark.sum(:amount)
    @lisk_total = Contribution.lisk.sum(:amount)
    @shift_total = Contribution.shift.sum(:amount)
    @oxy_total = Contribution.oxy.sum(:amount)
    @zcoin_total = Contribution.zcoin.sum(:amount)
    @pivx_total = Contribution.pivx.sum(:amount)
    @reddcoin_total = Contribution.reddcoin.sum(:amount)
    @raiblocks_total = Contribution.raiblocks.sum(:amount)

    @btc_hardcap = Contribution.pluck(:btc_amount).sum

    @early_contributions_open = DateTime.now >= EARLY_CONTRIB_OPEN_AT

    if session[:announcement2].blank?
      @announcement = true
      session[:announcement2] = true
    end
  end

  def root
    locale = params[:locale] || I18n.locale
    redirect_to(root_path(locale))
  end

  def newsletter
    Newsletter.subscribe(params[:email])
    respond_to { |format| format.js }
  end

  def contacts
    @res = JSON::parse RestClient.get(RECAPTCHA_VERIFY_URL, params: {
      secret: ENV['RECAPTCHA_SECRET_KEY'],
      response: params['g-recaptcha-response'],
      remoteip: request.remote_ip
    }).body

    if @res['success']
      SiteMailer.contacts(contacts_params).deliver_now
    end

    respond_to {|f| f.js }
  end

  def refund
    return if request.get?
    @res = JSON::parse RestClient.get(RECAPTCHA_VERIFY_URL, params: {
      secret: ENV['RECAPTCHA_SECRET_KEY'],
      response: params['g-recaptcha-response'],
      remoteip: request.remote_ip
    }).body

    if @res['success']
      SiteMailer.refund_req(current_user.username, refund_params).deliver_now
    end

    respond_to {|f| f.js }
  end

  private
  def contacts_params
    params.permit(:email, :message)
  end

  def refund_params
    params.permit(:first_name, :last_name, :email, :seed, :reason, :address)
  end
end
