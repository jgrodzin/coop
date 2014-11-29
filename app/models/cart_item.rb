class CartItem < ActiveRecord::Base
  validates :product, :shopping_cart, presence: true
  belongs_to :shopping_cart
  belongs_to :product
end
