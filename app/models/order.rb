class Order < ApplicationRecord
  include AASM

  monetize :total_amount_cents, :total_items_costs_cents

  enum state: { pending: 0, paid: 1, processing: 2, shipped: 3, delivered: 4, returned: 5 }

  belongs_to :user, optional: false
  belongs_to :shipping_address, optional: true
  belongs_to :card, optional: true

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  validates :shipping_address, presence: true, unless: :pending?
  validates :card, presence: true, unless: :pending?

  validate :user_shipping_address, if: :shipping_address_id_changed?
  validate :user_order, if: :card_id_changed?
  validates_associated :line_items

  DELIVERY_COST = Money.new(1000)

  self.per_page = 20

  aasm column: :state, whiny_persistence: true, no_direct_assignment: true do
    state :pending, initial: true
    state :paid, :processing, :shipped, :delivered, :returned

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :process do
      transitions from: %i[paid shipped], to: :processing
    end

    event :ship do
      transitions from: %i[processing delivered], to: :shipped
    end

    event :deliver do
      transitions from: %i[shipped returned], to: :delivered
    end

    event :return do
      transitions from: :delivered, to: :returned
    end
  end

  def total_items_amount
    line_items.sum(&:total_cost)
  end

  def update_cart(items)
    items.each do |item|
      line_item = line_items.find_by(id: item[:id])

      line_item ||= line_items.find_or_initialize_by(product_id: item[:product_id]) if item[:product_id]

      if line_item.present? && !line_item.update(quantity: item[:quantity])
        errors[:base] << "Quantity you requested for '#{line_item.product&.name}' is not available."
      end
    end

    errors.blank?
  end

  def update_total_ammount
    update(total_amount: total_items_amount + DELIVERY_COST)
  end

  def pay_stripe_order
    stripe_order_service = StripeServices::Order.new(id)

    return unless stripe_order_service.prepare_order && stripe_order_service.pay_stripe_order

    update_inventory
    pay && save
  end

  def active_shipping_address
    shipping_address || user.shipping_addresses.active.first
  end

  def active_card
    card || user.cards.first
  end

  private

  def update_inventory
    line_items.each do |line_item|
      sku = line_item.sku
      sku.update(inventory: sku.inventory - line_item.quantity)
    end
  end

  def user_shipping_address
    return unless shipping_address && !user.shipping_addresses.include?(shipping_address)

    @errors.add(:shipping_address, "dens't belongs to user")
  end

  def user_order
    return unless card && !user.cards.include?(card)

    @errors.add(:card, "dens't belongs to user")
  end
end
