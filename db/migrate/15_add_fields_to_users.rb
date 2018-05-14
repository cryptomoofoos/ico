class AddFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_column :users, :eth_address, :string
    add_column :users, :ark_address, :string
    add_column :users, :lisk_address, :string
    add_column :users, :shift_address, :string
    add_column :users, :oxy_address, :string
    add_column :users, :raiblocks_address, :string

    add_column :users, :is_forwarder, :boolean, default: false

    add_column :users, :referral_code, :string, null: false
    add_column :users, :referred_by, :string

    add_column :users, :contribution_bonus, :integer

    add_index :users, :referral_code, unique: true
    add_index :users, :eth_address, unique: true
    add_index :users, :ark_address, unique: true
    add_index :users, :lisk_address, unique: true
    add_index :users, :shift_address, unique: true
    add_index :users, :oxy_address, unique: true
    add_index :users, :raiblocks_address, unique: true
  end
end
