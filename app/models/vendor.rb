class Vendor < ActiveRecord::Base
  validates :name, :rep, presence: true

  has_many :products
end
