class ProductsController < ApplicationController
  def index
    @products = Product.all.group_by(&:vendor)
  end


  # def update
  #   @product = Products.find(params[:id])

  #   if @product.update_attributes(product_attributes)
  #     redirect_to product_path(@product)
  #   else
  #     render :edit
  #   end
  # end

  # private

  # def product_attributes
  #   params.require(:product).permit(:price)
  # end
end
