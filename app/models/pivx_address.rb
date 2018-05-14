class PivxAddress < ApplicationRecord
  belongs_to :user, required: false
  validates_presence_of :address
  validates_uniqueness_of :address

  def self.assigned
    where('user_id IS NOT NULL')
  end

  def self.unconfirmed
    where(status: :unconfirmed)
  end
end
