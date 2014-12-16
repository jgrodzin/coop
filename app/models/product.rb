class Product < ActiveRecord::Base
  validates :name, :vendor_id, :event_id, presence: true

  belongs_to :event
  belongs_to :vendor
  has_many :cart_items

  def self.sum_for_cart(cart_id)
    Product.joins(cart_items: :shopping_cart).where("shopping_carts.id = ?", cart_id).sum(:price_cents)
  end

  monetize :price_cents, allow_null: true
end
