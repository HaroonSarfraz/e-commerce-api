class StripeServices::Sku < StripeServices::Base
  def initialize(sku_id)
    @sku = Sku.find(sku_id)
    @product = @sku.product
  end

  # rubocop:disable Metrics/MethodLength
  def create
    stripe_sku = Stripe::SKU.create({
                                      currency: @sku.price.currency_as_string,
                                      price: @sku.price_cents,
                                      product: @product.stripe_product_id,
                                      attributes: {
                                        size: @sku.size || 'None',
                                        color: @sku.color || 'None'
                                      },
                                      inventory: {
                                        type: 'finite',
                                        quantity: @sku.inventory
                                      }
                                    })

    @sku.update_column(:stripe_sku_id, stripe_sku.id) # rubocop:disable Metrics/SkipsModelValidations
  rescue StandardError => e
    render_error(e)
  end
  # rubocop:enable Metrics/MethodLength

  def update
    Stripe::SKU.update(
      @sku.stripe_sku_id,
      { active: false }
    )

    create
  rescue StandardError => e
    render_error(e)
  end
end
