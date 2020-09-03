class StripeServices::Order < StripeServices::Base
  def initialize(product_id)
    @order = Order.find(product_id)
  end

  def prepare_order
    stripe_order = Stripe::Order.create({
                                          currency: @order.total_amount.currency_as_string,
                                          email: @order.user.email,
                                          items: @order.line_items.map(&:stripe_item),
                                          shipping: {
                                            name: @order.user.display_name,
                                            address: @order.active_shipping_address&.stripe_address
                                          }
                                        })

    @order.update(stripe_order_id: stripe_order.id)
  rescue StandardError => e
    render_error(e)
  end

  def pay_stripe_order
    stripe_order = Stripe::Order.pay(
      @order.stripe_order_id,
      { customer: @order.user.stripe_customer_id }
    )

    stripe_order.status == 'paid'
  rescue StandardError => e
    render_error(e)
  end
end
