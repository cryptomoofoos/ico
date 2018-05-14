File.readlines('data/zcoin_addresses.txt').each do |address|
  address.strip!
  ZcoinAddress.find_or_create_by!(address: address)
end
