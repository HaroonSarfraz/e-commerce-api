module Api::V1::Customer
  class StripeController < MainController
    def create_customer
      current_user.create_stripe_customer(customer_params[:secret_key])

      render json: { success: true }, status: :ok
    end

    private

    def customer_params
      params.permit(:secret_key)
    end
  end
end
