class CreateReddcoinAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :reddcoin_addresses do |t|
      t.belongs_to :user, foreign_key: true
      t.string :address, null: false
      t.string :status, default: :unconfirmed, null: false
      t.timestamps
    end

    # add_index :btc_addresses, :user_id, unique: true
  end
end
