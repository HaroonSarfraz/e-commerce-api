module Api::V1::Customer
  class ProductsController < MainController
    before_action :set_product, only: [:show]
    before_action :set_category, only: [:index]

    def index
      @products = Product.all.includes(:sku)
      @products = @products.where(category: @category) if @category
      @products = @products.search_for(params[:search_keyword]) if params[:search_keyword].present?
    end

    def show; end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def set_category
      @category = Category.find_by(id: params[:category_id]) if params[:category_id]
    end
  end
end
