# inventory for shop
class Inventory < ActiveRecord::Base
  belongs_to :event
  belongs_to :product
end
