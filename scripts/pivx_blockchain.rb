PivxAddress.assigned.unconfirmed.each do |wallet|
  begin
    user = wallet.user
    body = RestClient.get("https://chainz.cryptoid.info/pivx/api.dws?q=getbalance&a=#{wallet.address}&key=be507def388c")
    received = JSON.parse(body)

    ActiveRecord::Base.transaction do
      wallet.status = :confirmed
      wallet.save!
      user.contributions.create!(currency: :pivx, amount: received)
    end
  rescue => e
    puts e
  end
end
