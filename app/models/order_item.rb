class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :shopping_cart

  # validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product, :shopping_cart, presence: true

  def unit_price
    if persisted?
      self[:unit_price]
    else
      produce.price
    end
  end

  def total_price
    unit_price * quantity
  end
end
