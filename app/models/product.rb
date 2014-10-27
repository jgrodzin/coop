class Product < ActiveRecord::Base
  validates :name, :vendor_id, presence: true
  belongs_to :vendor

  monetize :price_cents, :allow_nil => true
end
