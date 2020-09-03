class LineItem < ApplicationRecord
  monetize :cost_cents

  belongs_to :order
  belongs_to :product

  has_one :sku, through: :product

  validates :quantity, presence: true

  validate :available_quantity

  after_commit :update_order_cost

  def update_order_cost
    order.update_total_ammount
  end

  def stripe_item
    {
      type: 'sku',
      parent: product.sku.stripe_sku_id,
      quantity: quantity
    }
  end

  def total_cost
    cost * quantity
  end

  private

  def available_quantity
    return unless product&.inventory.to_i < quantity

    errors[:quantity] << "you requested for '#{product&.name}' is not available."
  end
end
