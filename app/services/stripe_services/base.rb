class StripeServices::Base
  def render_error(error)
    puts "Stripe Error: #{error}"
    error
  end
end
