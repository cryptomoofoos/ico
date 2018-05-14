url = 'https://wallet.shiftnrg.org/api/transactions?recipientId=8716127454558448351S'
body = RestClient.get(url).body
data = JSON.parse(body)

exit unless data['success']

data['transactions'].each do |tx|
  begin
    next if tx['senderId'].upcase == '8716127454558448351S'
    next unless tx['confirmations'].to_i > 0

    trans = Contribution.shift.find_by_tx_hash(tx['id'])
    next if trans

    user = User.where('UPPER(shift_address) = ?', tx['senderId'].upcase).first
    next if user.blank?

    amount = tx['amount'] / 100_000_000.0
    user.contributions.create!(currency: :shift, sender: tx['senderId'], amount: amount, tx_hash: tx['id'])
  rescue => e
    puts e
  end
end
