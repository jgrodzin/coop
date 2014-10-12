class ShoppingCart < ActiveRecord::Base
  belongs_to :member
  belongs_to :event
  has_many :products, through: :event, source: :event_products
end
