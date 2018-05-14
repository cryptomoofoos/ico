url = 'https://explorer.ark.io:8443/api/getTransactionsByAddress?address=AGyJLEatH22atAeSxsrScyWzdDu1bdLXn1&limit=50&offset=0'
body = RestClient.get(url).body
data = JSON.parse(body)

exit unless data['success']

data['transactions'].each do |tx|
  begin
    next unless tx['confirmations'].to_i > 0

    trans = Contribution.ark.find_by_tx_hash(tx['id'])
    next if trans

    user = User.where('UPPER(ark_address) = ?', tx['senderId'].upcase).first
    next if user.blank?

    amount = tx['amount'] / 100_000_000.0
    user.contributions.create!(currency: :ark, sender: tx['senderId'], amount: amount, tx_hash: tx['id'])
  rescue => e
    puts e
  end
end

data['transactions'].select do |tx|
  next unless tx['confirmations'].to_i > 0

  trans = Contribution.ark.find_by_tx_hash(tx['id'])
  next if trans

  true
end
