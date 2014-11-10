class Event < ActiveRecord::Base
  validates :team_id, :date, presence: true

  belongs_to :team
  has_many :inventory
  # has_many :sellable_products, through: :inventory, source: :product, foreign_key: :product_id
  has_many :involved_vendors, through: :inventory,
              source: :product, foreign_key: :vendor_id

  has_many :shopping_carts

  def date_in_words
    date.strftime("%B %e, %Y")
  end
end

