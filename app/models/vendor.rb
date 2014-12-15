class Vendor < ActiveRecord::Base
  validates :name, presence: true

  has_many :products, dependent: :destroy
end
