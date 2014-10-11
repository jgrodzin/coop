class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
    @vendor_products = Product.where(vendor_id: params[:id])
  end
end
