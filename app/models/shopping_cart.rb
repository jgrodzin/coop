class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true
  belongs_to :event
  belongs_to :member
  has_many :cart_items

  def add_item(product)
    cart_items << CartItem.create(product: product)
  end

  def calculate_sub_total
      cart_items.map { |item| item.amount.present? ? (item.price_cents * item.amount / 100) : 0 }.sum
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
