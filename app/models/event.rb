class Event < ActiveRecord::Base
  validates :team_id, :date, presence: true

  belongs_to :team
  has_many :event_products
  has_many :involved_vendors, through: :event_products,
              source: :product, foreign_key: :vendor_id

  def date_in_words
    date.strftime("%B %e, %Y")
  end
end
