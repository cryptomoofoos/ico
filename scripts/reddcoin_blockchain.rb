ReddcoinAddress.assigned.unconfirmed.each do |wallet|
  begin
    user = wallet.user
    body = RestClient.get("http://live.reddcoin.com/api/addr/#{wallet.address}/balance")
    received = JSON::parse(body)

    next unless received > 0

    ActiveRecord::Base.transaction do
      user.contributions.create!(currency: :reddcoin, amount: received)
      wallet.status = :confirmed
      wallet.save!
    end
  rescue => e
    puts e
  end
end
