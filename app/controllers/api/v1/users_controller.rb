module Api::V1::Customer
  class UsersController < MainController
    def create_card
      current_user.create_stripe_customer(customer_params[:secret_key])

      render json: { success: true }, status: :ok
    end

    def current
      @user = current_user
      render 'show'
    end

    private

    def customer_params
      params.permit(:secret_key)
    end
  end
end
