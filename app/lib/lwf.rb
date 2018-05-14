class LWF
  BONUS = 10
  BONUS_PER_BTC = 0.5
  BONUS_LIMIT = 45

  # CONVERT TO USD
  def self.eth_to_usd
    $redis.get("rates:XETHZUSD").to_f
  end

  def self.btc_to_usd
    $redis.get("rates:XXBTZUSD").to_f
  end

  def self.ark_to_usd
    $redis.get("rates:ARK-USD").to_f
  end

  def self.lisk_to_usd
    $redis.get("rates:LISK-USD").to_f
  end

  def self.shift_to_usd
    $redis.get("rates:SHIFT-USD").to_f
  end

  def self.oxy_to_usd
    $redis.get("rates:OXY-USD").to_f
  end

  def self.zcoin_to_usd
    $redis.get("rates:ZCOIN-USD").to_f
  end

  def self.pivx_to_usd
    $redis.get("rates:PIVX-USD").to_f
  end

  def self.reddcoin_to_usd
    $redis.get("rates:RDD-USD").to_f
  end

  def self.raiblocks_to_usd
    $redis.get("rates:RAIBLK-USD").to_f
  end

  def self.update_exchange_rates
    data = JSON::parse(RestClient.get('https://api.coinmarketcap.com/v1/ticker/?convert=usd&limit=3000'))
    btc = data.select {|row| row['id'] == 'bitcoin' }.first
    eth = data.select {|row| row['id'] == 'ethereum' }.first
    ark = data.select {|row| row['id'] == 'ark' }.first
    lisk = data.select {|row| row['id'] == 'lisk' }.first
    shift = data.select {|row| row['id'] == 'shift' }.first
    oxy = data.select {|row| row['id'] == 'oxycoin' }.first
    zcoin = data.select {|row| row['id'] == 'zcoin' }.first
    pivx = data.select {|row| row['id'] == 'pivx' }.first
    rdd = data.select {|row| row['id'] == 'reddcoin' }.first
    raiblk = data.select {|row| row['id'] == 'raiblocks' }.first

    $redis.set("rates:XETHZUSD", eth['price_usd']) if eth['price_usd'].present?
    $redis.set("rates:XXBTZUSD", btc['price_usd']) if btc['price_usd'].present?
    $redis.set("rates:ARK-USD", ark['price_usd']) if ark['price_usd'].present?
    $redis.set("rates:LISK-USD", lisk['price_usd']) if lisk['price_usd'].present?
    $redis.set("rates:SHIFT-USD", shift['price_usd']) if shift['price_usd'].present?
    $redis.set("rates:OXY-USD", oxy['price_usd']) if oxy['price_usd'].present?
    $redis.set("rates:ZCOIN-USD", zcoin['price_usd']) if zcoin['price_usd'].present?
    $redis.set("rates:PIVX-USD", pivx['price_usd']) if pivx['price_usd'].present?
    $redis.set("rates:RDD-USD", rdd['price_usd']) if rdd['price_usd'].present?
    $redis.set("rates:RAIBLK-USD", raiblk['price_usd']) if raiblk['price_usd'].present?
  end
end
