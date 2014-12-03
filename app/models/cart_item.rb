class CartItem < ActiveRecord::Base
  validates :product, :shopping_cart, presence: true
  validates_numericality_of :amount, on: :update
  belongs_to :shopping_cart
  belongs_to :product

  monetize :price_cents, allow_null: true

  def calculate_sub_total_price
    amount.present? ? (product.price * amount) : 0
  end
end
