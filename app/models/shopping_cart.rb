class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true

  belongs_to :member
  belongs_to :event
  has_many :order_items
  # has_many :purchased_products, class_name: "Product", through: :event, source: :sellable_products

  before_save :update_sub_total

  def sub_total
    order_items.map { |product| product.valid? ? (product.price_cents * quantity) : 0 }.sum
  end

  private

  # def set_event_id
  #   self.event = Event.find(params[:event_id])
  # end

  def update_sub_total
    # self[:sub_total] = sub_total
  end
end

# ShoppingCart
# belongs to a member
# belongs to an event
# has many products from event inventory

# can give sub_total for individual products (product.price * amount)
# has a total of all products (produce.sub_total.inject(:+))
