File.readlines('data/pivx_addresses.txt').each do |address|
  address.strip!
  PivxAddress.find_or_create_by!(address: address)
end
