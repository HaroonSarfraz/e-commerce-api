module Api::V1::Customer
  class CardsController < MainController
    before_action :set_card, only: [:destroy]

    def index
      @cards = current_user.cards
    end

    def create
      StripeServices::Cards.new(current_user.id, card_params[:secret_key]).create

      @cards = current_user.cards
      render 'index'
    end

    def destroy
      if @card&.destroy
        render json: { success: true }, status: :ok
      else
        render_errors(@card)
      end
    end

    private

    def set_card
      @card = current_user.cards.find_by(id: params[:id]) if params[:id]
    end

    def card_params
      params.permit(:secret_key)
    end
  end
end
