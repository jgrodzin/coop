class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true
  belongs_to :member
  belongs_to :event
  has_many :order_items, class_name: "Product", through: :event, source: :sellable_products

  before_save :update_sub_total

  def update_sub_total
    order_items.map { |item| item.valid? ? (item.quantity * item.unit_price) : 0 }.sum
  end

  def update_sub_total
    self[:sub_total] = sub_total
  end

  # def calculate_total
  #   binding.pry
  #   order_items.sub_total_cents += order_items.total_cents
  # end
end

# ShoppingCart
# belongs to a member
# belongs to an event
# has many products from event inventory

# can give sub_total for individual products (product.price * amount)
# has a total of all products (produce.sub_total.inject(:+))
