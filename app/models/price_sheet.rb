class PriceSheet < ActiveRecord::Base
  validates :member_id, :event_id, presence: true

  belongs_to :member
  belongs_to :event
  has_many :products, through: :event, source: :event_products
end
