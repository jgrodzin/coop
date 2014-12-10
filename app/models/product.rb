class Product < ActiveRecord::Base
  validates :name, :vendor_id, :event_id, presence: true

  belongs_to :event
  belongs_to :vendor
  has_many :cart_items

  monetize :price_cents, allow_null: true
end
