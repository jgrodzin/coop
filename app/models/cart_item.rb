class CartItem < ActiveRecord::Base
  validates :product, :shopping_cart, presence: true
  validates_numericality_of :amount

  belongs_to :shopping_cart
  belongs_to :product

  monetize :price_cents, allow_null: true

  def calculate_sub_total_price
    product.price * amount
  end
end
