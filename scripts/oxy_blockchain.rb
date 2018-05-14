url = 'https://wallet.oxycoin.io/api/transactions?recipientId=15287186081845849630X'
body = RestClient.get(url).body
data = JSON.parse(body)

exit unless data['success']

data['transactions'].each do |tx|
  begin
    next if tx['senderId'].upcase == '15287186081845849630X'
    next unless tx['confirmations'].to_i > 0


    trans = Contribution.oxy.find_by_tx_hash(tx['id'])
    next if trans

    user = User.where('UPPER(oxy_address) = ?', tx['senderId'].upcase).first
    next if user.blank?

    amount = tx['amount'] / 100_000_000.0
    user.contributions.create!(currency: :oxy, sender: tx['senderId'], amount: amount, tx_hash: tx['id'])
  rescue => e
    puts e
  end

  sleep 1
end
