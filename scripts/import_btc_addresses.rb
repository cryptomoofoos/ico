File.readlines('data/btc_addresses.txt').each do |address|
  address.strip!
  BtcAddress.find_or_create_by!(address: address)
end
