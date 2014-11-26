class Product < ActiveRecord::Base
  validates :name, :vendor_id, presence: true

  belongs_to :vendor
  has_many :inventories
  has_many :cart_items

  # belongs_to :event, through: :inventory

  monetize :price_cents, allow_null: true

  def sub_total_calc
    # self.map { |product| product.valid? ? (product.price_cents * quantity) : 0 }.sum
    # self.price_cents */
    quantity = 2
    price * quantity
  end
end
