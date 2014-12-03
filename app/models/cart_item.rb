class CartItem < ActiveRecord::Base
  validates :product, :shopping_cart, presence: true
  belongs_to :shopping_cart
  belongs_to :product

  monetize :price_cents, allow_null: true

  # def price_cents
  #   if amount.present?
  #     price * amount
  #   else
  #     price
  #   end
  # end
end
