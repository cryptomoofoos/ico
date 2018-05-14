class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.belongs_to :user, foreign_key: true
      t.decimal :balance, default: 0, null: false

      t.timestamps
    end
  end
end
