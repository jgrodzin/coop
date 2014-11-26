class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true
  belongs_to :event
  belongs_to :member
  # has_many :items, through: :event, source: :products
  has_many :cart_items
  # has_many :products, through: :cart_items

  def add_item(product)
    cart_items << CartItem.create(product: product)
  end

  # def update_sub_total
  #   order_items.map { |item| item.valid? ? (item.quantity * item.unit_price) : 0 }.sum
  # end

  # def update_sub_total
  #   self[:sub_total] = sub_total_cents
  # end

  # def calculate_total
  #   order_items.sub_total_cents += order_items.total_cents
  # end
end

# ShoppingCart
# belongs to a member
# belongs to an event
# has many products from event inventory

# can give sub_total for individual products (product.price * amount)
# has a total of all products (produce.sub_total.inject(:+))
