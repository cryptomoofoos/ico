class User < ApplicationRecord
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :tx_btc_address, class_name: 'BtcAddress'
  has_one :tx_eth_address, class_name: 'EthAddress'

  has_many :contributions
  has_many :transactions # TO BE REMOVED
  has_many :btc_transactions # TO BE REMOVED

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :eth_address, uniqueness: { case_sensitive: false }, allow_blank: true # TO BE REMOVED
  validates :ark_address, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :lisk_address, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :shift_address, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :oxy_address, uniqueness: { case_sensitive: false }, allow_blank: true

  before_create :set_role, :set_referral_code
  after_create :set_balance, :send_registration_resume

  def address(cur)
    self.send("#{cur}_address")
  end

  def admin?
    self.role == 'admin'
  end

  #def email_required?
  #  false
  #end

  def is_forwarder!
    self.is_forwarder = true
    self.save!
  end

  def assign_btc_address!
    return self.tx_btc_address if self.tx_btc_address.present?
    btc_address = BtcAddress.where(user_id: nil, btc_transaction_id: nil).first
    raise 'No BTC Addresses available!' if btc_address.blank?
    self.tx_btc_address = btc_address
    self.save!
  end

  def assign_eth_address!
    return self.tx_eth_address if self.tx_eth_address.present?
    eth_address = EthAddress.where(user_id: nil).first
    raise 'No ETH Addresses available!' if eth_address.blank?
    self.tx_eth_address = eth_address
    self.save!
  end

  def assign_zcoin_address!
    address = ZcoinAddress.where(user_id: nil).first
    raise 'No ZCoin Addresses available!' if address.blank?
    address.user = self
    address.save!
    address
  end

  def assign_pivx_address!
    address = PivxAddress.where(user_id: nil).first
    raise 'No Pivx Addresses available!' if address.blank?
    address.user = self
    address.save!
    address
  end

  def assign_reddcoin_address!
    address = ReddcoinAddress.where(user_id: nil).first
    raise 'No Reddcoin Addresses available!' if address.blank?
    address.user = self
    address.save!
    address
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    return nil if login.blank?

    query = "lower(username) = :login OR lower(email) = :login"
    where(conditions.to_h).where([query, login: login.downcase]).first
  end

  private
  def send_registration_resume
    SiteMailer.registration(self).deliver_now
  end

  def set_referral_code
    self.referral_code = SecureRandom.hex(4)
  end

  def set_role
    return true unless self.is_forwarder?
    self.role == 'forwarder'
  end

  def set_balance
    self.create_wallet
  end
end
