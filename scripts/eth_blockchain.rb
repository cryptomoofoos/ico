EthAddress.where('user_id IS NOT NULL').each do |wallet|
  addr = wallet.address
  user = wallet.user

  begin
    body = RestClient.get("https://api.etherscan.io/api?module=account&action=txlist&address=#{addr}&tag=latest&apikey=FIXRKK8K58XUWWXC7ATX1IXASZU5QY5D8G").body
  rescue
    next
  end

  JSON.parse(body)['result'].each do |tx|
    begin
      next if tx['from'].downcase == addr.downcase
      next unless tx['confirmations'].to_i > 0

      trans = Contribution.eth.find_by_tx_hash(tx['hash'])
      next if trans

      amount = tx['value'].to_i / 1_000_000_000_000_000_000.0
      user.contributions.create!(currency: :eth, amount: amount, sender: tx['from'], tx_hash: tx['hash'])
    rescue => e
      puts e
    end
  end
end
