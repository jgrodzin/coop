class EventProductsController < ApplicationController
  def index
    @event_products = EventProduct.all.map(&:product)
    # @event_date = EventProduct.all.map(&:event).map(&:date)
    #
  end

  def show
    @event_products = EventProduct.all.map(&:product)
    binding.pry
    @event_product = @event_products.find(params[:id])
  end
end

# events....
# has a price sheet with EventProducts
# price sheets only show products for specific event!

# current order ==> is same as Event Products?
# Should hold ALL information regarding the order...
## product info: quantity purchased, vendors, etc.
## CRUD functionality here.

## What is Products doing now? ALl prodcuts not really necessary
# Does EventProducts get informoation from products still... or is that moot.


## gonna need that nested route
# event/1/event_products
