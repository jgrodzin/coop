class CartItem < ActiveRecord::Base
  validates :shopping_cart, :product, presence: true
  validates :amount, allow_nil: false, numericality: { greater_than_or_equal_to: 1 }
  validates :product_id, presence: true, uniqueness: { scope: :shopping_cart, message: "Product already in cart." }

  belongs_to :shopping_cart
  belongs_to :product

  def calculate_sub_total_price
    product.price * amount
  end

  def self.sum_for_cart(cart_id)
    CartItem.joins(cart_items: :shopping_cart).where("shopping_carts.id = ?", cart_id).sum(:price_cents) * amount
  end
end
