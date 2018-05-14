api_key = ''

BtcAddress.where('user_id IS NOT NULL').each do |wallet|
  user = wallet.user
  body = RestClient.get("https://api.blockcypher.com/v1/btc/main/addrs/#{wallet.address}?token=#{api_key}")
  data = JSON::parse(body)

  txs = data['txrefs'] || []
  un_txs = data['unconfirmed_txrefs'] || []

  txs += un_txs

  next if txs.blank?

  txs.each do |tx|
    begin
      next if tx['spent'].nil? # skip if output

      trans = Contribution.btc.find_by_tx_hash(tx['tx_hash'])
      next if trans

      amount = tx['value'] / 100000000.0
      user.contributions.create!(currency: :btc, amount: amount, tx_hash: tx['tx_hash'])
    rescue => e
      puts e
    end
  end

  sleep 1
end
