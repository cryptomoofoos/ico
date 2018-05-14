class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.belongs_to :user, foreign_key: true
      t.string :currency, null: false
      t.decimal :amount, null: false
      t.string :sender
      t.string :tx_hash, index: true

      t.decimal :rate, null: false
      t.decimal :btc_rate, null: false
      t.decimal :btc_amount, null: false
      t.decimal :btc_amount_no_bonus, null: false
      t.integer :bonus_pct, null: false
      t.decimal :bonus_per_btc, null: false

      t.timestamps
    end
  end
end
