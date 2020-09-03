class StripeServices::Product < StripeServices::Base
  def initialize(product_id)
    @product = Product.find(product_id)
  end

  def create
    stripe_product = Stripe::Product.create({
                                              name: @product.name,
                                              type: 'good',
                                              attributes: %w[size color],
                                              description: @product.description
                                            })

    @product.update(stripe_product_id: stripe_product.id)
  rescue StandardError => e
    render_error(e)
  end

  def update
    Stripe::Product.update(
      @product.stripe_product_id,
      {
        name: @product.name,
        attributes: %w[size color],
        description: @product.description
      }
    )
  rescue StandardError => e
    render_error(e)
  end
end
