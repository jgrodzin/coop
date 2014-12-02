class Event < ActiveRecord::Base
  validates :team_id, presence: true

  belongs_to :team
  has_many :inventories
  has_many :products, through: :inventories, source: :product, foreign_key: :product_id
  has_many :vendors, through: :inventories, source: :product, foreign_key: :vendor_id
  has_many :shopping_carts

  # scope :set_cart, -> (current_member) { where(member_id: current_member.id) }

  def date_in_words
    return nil if date.blank?
    date.strftime("%B %e, %Y")
  end
end
