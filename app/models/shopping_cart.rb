
class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true

  belongs_to :member
  belongs_to :event
  has_many :purchased_products, class_name: "Product", through: :event, source: :sellable_products

  def sub_total
    purchased_products.map { |product| product.valid? ? (product.price_cents * quantity) : 0 }.sum
  end

  def update_sub_total
    self[:sub_total] = sub_total
  end
end

# ShoppingCart
# belongs to a member
# belongs to an event
# has many products from event inventory

# can give sub_total for individual products (product.price * amount)
# has a total of all products (produce.sub_total.inject(:+))
