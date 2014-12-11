class Event < ActiveRecord::Base
  validates :team_id, presence: true

  belongs_to :team
  has_many :products
  has_many :vendors, through: :products
  has_many :shopping_carts

  scope :past_events, -> { where("date < ?", Date.today) }
  scope :upcoming_events, -> { where("date >= ?", Date.today) }

  def date_in_words
    return nil if date.blank?
    date.strftime("%B %e, %Y")
  end
end
