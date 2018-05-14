url = 'http://94.237.28.66:8000/api/transactions?recipientId=10214293569612168828L'
body = RestClient.get(url).body
data = JSON.parse(body)

exit unless data['success']

data['transactions'].each do |tx|
  begin
    next if tx['senderId'].upcase == '10214293569612168828L'
    next unless tx['confirmations'].to_i > 0

    trans = Contribution.lisk.find_by_tx_hash(tx['id'])
    next if trans

    user = User.where('UPPER(lisk_address) = ?', tx['senderId'].upcase).first
    next if user.blank?

    amount = tx['amount'] / 100_000_000.0
    user.contributions.create!(currency: :lisk, sender: tx['senderId'], amount: amount, tx_hash: tx['id'])
  rescue => e
    puts e
  end
end
