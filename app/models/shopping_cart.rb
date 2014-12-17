class ShoppingCart < ActiveRecord::Base
  validates :member_id, :event_id, presence: true
  belongs_to :event
  belongs_to :member
  has_many :cart_items

  monetize :total_cents

  def sub_total_price
    cart_items.includes(:product).map { |item| (item.product.price * item.amount) }.reduce(:+)
  end

  def tax
    sub_total_price * 0.0225 if sub_total_price.present?
  end

  def total_price
    tax + sub_total_price if tax.present?
  end
end
