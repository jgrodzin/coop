class Event < ActiveRecord::Base
  validates :team_id, presence: true

  belongs_to :team
  has_many :inventories
  has_many :sellable_products, through: :inventories, source: :product, foreign_key: :product_id
  has_many :vendors, through: :inventories, source: :product, foreign_key: :vendor_id

  has_many :shopping_carts

  def date_in_words
    date.strftime("%B %e, %Y")
  end
end
