class StripeServices::Customer < StripeServices::Base
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def create
    customer = Stripe::Customer.create({
                                         description: "Customer for #{@user.email}",
                                         source: @secret_key
                                       })
    @user.update(stripe_customer_id: customer.id)
  rescue StandardError => e
    render_error(e)
  end
end
