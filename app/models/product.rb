class Product < ActiveRecord::Base
  UNIT_TYPES = %w(lbs oz each bag dozen pkg)

  belongs_to :event
  belongs_to :vendor
  has_many :cart_items

  validates :name, :vendor_id, :event_id, presence: true

  monetize :price_cents, allow_null: true

  def total_inventory_price
    total_amount_purchased * price if total_amount_purchased.present?
  end
end
