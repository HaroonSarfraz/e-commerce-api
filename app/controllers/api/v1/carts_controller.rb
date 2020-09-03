module Api::V1::Customer
  class CartsController < MainController
    before_action :set_order

    def show
      @line_items = @order.line_items.includes(:product)
      @address = @order.active_shipping_address
      @card = @order.active_card
    end

    def update
      if request.patch?
        update_line_item
      else
        update_cart
      end
    end

    def destroy
      line_item = @order.line_items.find(params[:line_item_id])

      if line_item.destroy
        @line_items = @order.line_items
        render 'show', status: :ok
      else
        render_errors(line_item)
      end
    end

    def set_address
      @address = ShippingAddress.find_by(id: params[:address_id])
      if @order.update(shipping_address: @address)
        render 'show', status: :ok
      else
        render_errors(@order)
      end
    end

    def set_card
      @card = Card.find_by(id: params[:card_id])
      if @order.update(card: @card)
        render 'show', status: :ok
      else
        render_errors(@order)
      end
    end

    def process_order
      if @order.valid? && @order.pay_stripe_order
        render json: { success: true }, status: :ok
      else
        render_errors(@order)
      end
    rescue StandardError => e
      render_errors(e)
    end

    private

    def set_order
      @order = current_user.cart
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def line_item_params
      params.permit(:quantity)
    end

    def cart_params
      params.permit(line_items: %i[id product_id quantity])
    end

    def process_order_params
      params.permit(:shipping_address_id)
    end

    def update_line_item
      set_product

      line_item = @order.line_items.find_or_initialize_by(product: @product)

      if line_item.update(line_item_params.merge(cost: @product.price))
        render json: {}, status: :ok
      else
        render_errors(line_item)
      end
    end

    def update_cart
      if @order.update_cart(cart_params[:line_items])
        render json: {}, status: :ok
      else
        render_errors(@order)
      end
    end
  end
end
