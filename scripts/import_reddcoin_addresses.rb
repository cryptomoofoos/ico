File.readlines('data/reddcoin_addresses.txt').each do |address|
  address.strip!
  ReddcoinAddress.find_or_create_by!(address: address)
end
