class StripeServices::Cards < StripeServices::Base
  def initialize(user_id, secret_key)
    @user = User.find(user_id)
    @secret_key = secret_key
  end

  # rubocop:disable Metrics/MethodLength
  def create
    stripe_card = Stripe::Customer.create_source(
      @user.stripe_customer_id,
      {
        source: @secret_key
      }
    )

    card = Card.create!(
      user: @user,
      stripe_id: stripe_card.id,
      address_zip: stripe_card.address_zip,
      brand: stripe_card.brand,
      last4: stripe_card.last4,
      country: stripe_card.country,
      funding: stripe_card.funding,
      exp_month: stripe_card.exp_month,
      exp_year: stripe_card.exp_year
    )
    card
  rescue StandardError => e
    render_error(e)
  end
  # rubocop:enable Metrics/MethodLength
end
