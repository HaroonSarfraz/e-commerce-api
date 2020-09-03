class Sku < ApplicationRecord
  monetize :price_cents

  belongs_to :product, inverse_of: :sku

  validates :inventory, presence: true

  after_create :create_stripe_sku
  after_update :update_stripe_sku

  private

  def create_stripe_sku
    StripeServices::Sku.new(id).create
  end

  def update_stripe_sku
    StripeServices::Sku.new(id).update
  end
end
