class Event < ActiveRecord::Base
	belongs_to :team 
	has_many :event_products
	has_many :involved_vendors, through: :event_products, source: :product, foreign_key: :vendor_id# source: :products, foreign_key: :vendor_id
end
