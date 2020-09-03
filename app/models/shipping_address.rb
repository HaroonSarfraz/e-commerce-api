class ShippingAddress < ApplicationRecord
  acts_as_paranoid

  belongs_to :user, optional: false

  has_many :orders, dependent: :destroy

  validates :city, presence: true
  validates :country, presence: true
  validates :line1, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true

  scope :active, -> { where(active: true) }

  def stripe_address
    {
      line1: line1,
      city: city,
      state: state,
      postal_code: postal_code,
      country: country
    }
  end
end
