module Api::V1::Customer
  class ShippingAddressesController < MainController
    before_action :set_shipping_address, only: [:destroy]

    def index
      @addresses = current_user.shipping_addresses
    end

    def create
      @address = current_user.shipping_addresses.new(shipping_address_params)

      if @address.save
        render :show
      else
        render_errors(@address)
      end
    end

    def destroy
      if @address&.destroy
        render json: { success: true }, status: :ok
      else
        render_errors(@address)
      end
    end

    private

    def shipping_address_params
      params.fetch(:shipping_address).permit(:id, :country, :city, :line1, :line2, :state, :postal_code, :note,
                                             :first_name, :last_name, :phone_no)
    end

    def set_shipping_address
      @address = current_user.shipping_addresses.find_by(id: params[:id]) if params[:id]
    end
  end
end
