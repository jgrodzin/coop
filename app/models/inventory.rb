# inventory for shop
class Inventory < ActiveRecord::Base
  belongs_to :event
  belongs_to :product
  # has_many :products
  # accepts_nested_attr_for :products
end
