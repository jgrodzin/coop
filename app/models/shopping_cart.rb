class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true
  belongs_to :event
  belongs_to :member
  has_many :cart_items

  def calculate_total_price
    cart_items.map { |item| (item.product.price * item.amount) }.reduce(:+)
  end
end
