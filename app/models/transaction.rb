class Transaction < ApplicationRecord
  belongs_to :user

  before_create :set_tokens
  after_create :complete!

  validates_presence_of :user_id, :currency, :amount, :tx_hash

  def complete!
    ActiveRecord::Base.transaction do
      $redis.incrbyfloat("usd_total_recv", self.amount * self.rate)
      $redis.incrbyfloat("#{self.currency}_total_recv", self.amount)
    end
    SiteMailer.confirm_transaction(self.user).deliver_now
  end

  def cancel!
    ActiveRecord::Base.transaction do
      $redis.incrbyfloat("usd_total_recv", -(self.amount * self.rate))
      $redis.incrbyfloat("#{self.currency}_total_recv", -(self.amount))

      self.destroy!
    end
  end

  def self.eth
    where(currency: :eth)
  end

  def self.ark
    where(currency: :ark)
  end

  private
  def set_tokens
    self.rate = LWF.send("#{self.currency}_to_usd")
    self.btc_rate = LWF.send("btc_to_usd")
    self.btc_amount = self.amount * self.rate / self.btc_rate
  end
end
