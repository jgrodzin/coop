class CartItem < ActiveRecord::Base
  validates :shopping_cart, :product, presence: true
  validates_numericality_of :amount

  validates_uniqueness_of :product_id

  belongs_to :shopping_cart
  belongs_to :product

  def calculate_sub_total_price
    product.price * amount
  end

  def self.sum_for_cart(cart_id)
    CartItem.joins(cart_items: :shopping_cart).where("shopping_carts.id = ?", cart_id).sum(:price_cents) * amount
  end
end
