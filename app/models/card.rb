class Card < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  has_many :orders, dependent: :destroy

  validates :stripe_id, :brand, :last4, :country, :funding, :exp_month, :exp_year, presence: true
end
