class ExchangeController < BaseController
  def index
    btc_amount = params[:amount].to_f

    if params[:currency] != 'btc'
      rate = LWF.send("#{params[:currency]}_to_usd")
      btc_rate = LWF.btc_to_usd
      btc_amount = btc_amount * rate / btc_rate
    end

    btc = btc_amount

    bonus = LWF::BONUS_PER_BTC * btc_amount + LWF::BONUS
    bonus = LWF::BONUS_LIMIT if bonus > LWF::BONUS_LIMIT
    btc_amount = btc_amount + (btc_amount / 100 * bonus)

    btc_bonus = btc_amount

    render json: {btc: btc, btc_bonus: btc_bonus}
  end
end
