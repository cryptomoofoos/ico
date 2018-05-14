class EthAddress < ApplicationRecord
  belongs_to :user, required: false
  validates_presence_of :address
  validates_uniqueness_of :address
end
