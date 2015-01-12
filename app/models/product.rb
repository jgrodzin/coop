class Product < ActiveRecord::Base
  validates :name, :vendor_id, :event_id, presence: true

  belongs_to :event
  belongs_to :vendor
  has_many :cart_items

  monetize :price_cents, allow_null: true

  # def self.sum_for_cart(cart_id)
  #   Product.joins(cart_items: :shopping_cart).where("shopping_carts.id = ?", cart_id).sum(:price_cents)
  # end

  def total_inventory_price
    total_amount_purchased * price if total_amount_purchased.present?
  end

  # def self.search(query)
  #   where("name like ?", "%#{query}")
  # end
end
