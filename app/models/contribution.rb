class Contribution < ApplicationRecord
  attr_reader :bypass_bonus_limit

  belongs_to :user

  before_save :calculate_reward
  after_create :send_notification

  validates_presence_of :user_id, :currency, :amount

  def bypass_bonus_limit=(bool)
    @bypass_bonus_limit = true if bool.to_s == "1"
  end

  def btc?
    self.currency == 'btc'
  end

  def eth?
    self.currency == 'eth'
  end

  def ark?
    self.currency == 'ark'
  end

  def lisk?
    self.currency == 'lisk'
  end

  def shift?
    self.currency == 'shift'
  end

  def oxy?
    self.currency == 'oxy'
  end

  def precision
    case self.currency
    when 'btc'
      7
    when 'eth'
      5
    when 'ark'
      2
    when 'lisk'
      2
    when 'shift'
      2
    else
      3
    end
  end

  def self.btc
    where(currency: :btc)
  end

  def self.eth
    where(currency: :eth)
  end

  def self.ark
    where(currency: :ark)
  end

  def self.lisk
    where(currency: :lisk)
  end

  def self.shift
    where(currency: :shift)
  end

  def self.oxy
    where(currency: :oxy)
  end

  def self.zcoin
    where(currency: :zcoin)
  end

  def self.pivx
    where(currency: :pivx)
  end

  def self.reddcoin
    where(currency: :reddcoin)
  end

  def self.raiblocks
    where(currency: :raiblocks)
  end

  private
  def calculate_reward
    self.rate ||= LWF.send("#{self.currency}_to_usd")

    if self.btc?
      self.btc_rate ||= self.rate
      self.btc_amount_no_bonus = self.amount
    else
      self.btc_rate ||= LWF.btc_to_usd
      self.btc_amount_no_bonus = self.amount * self.rate / self.btc_rate
    end

    if self.user.contribution_bonus.present?
      self.bonus_pct ||= self.user.contribution_bonus
      self.bonus_per_btc = 0
      bonus = self.bonus_pct
    else
      self.bonus_pct ||= LWF::BONUS
      self.bonus_per_btc ||= LWF::BONUS_PER_BTC
      bonus = self.bonus_per_btc * (self.btc_amount_no_bonus / 0.5) + self.bonus_pct

      if not self.bypass_bonus_limit and bonus > LWF::BONUS_LIMIT
        bonus = LWF::BONUS_LIMIT
      end
    end

    self.btc_amount = self.btc_amount_no_bonus + (self.btc_amount_no_bonus / 100 * bonus)

    return true if self.user.contribution_bonus.present? || self.btc_amount_no_bonus >= MINIMUM_BTC_CONTRIB
    raise "Contribution for user #{self.user.username}: must be greater or equal than #{MINIMUM_BTC_CONTRIB} BTC"
  end

  def send_notification
    SiteMailer.confirm_transaction(self.user).deliver_now
  end
end
