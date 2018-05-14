ZcoinAddress.assigned.unconfirmed.each do |wallet|
  begin
    user = wallet.user
    body = RestClient.get("https://explorer.zcoin.io/ext/getaddress/#{wallet.address}")
    received = JSON::parse(body)['received']

    ActiveRecord::Base.transaction do
      wallet.status = :confirmed
      wallet.save!
      user.contributions.create!(currency: :zcoin, amount: received)
    end
  rescue => e
    puts e
  end
end
