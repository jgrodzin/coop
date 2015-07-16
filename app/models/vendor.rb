class Vendor < ActiveRecord::Base
  validates :name, presence: true

  has_many :products, dependent: :destroy

  enum status: [:active, :archived]
  scope :active_vendors, -> { where(status: statuses[:active]) }
  scope :archived_vendors, -> { where(status: statuses[:archived]) }
end
