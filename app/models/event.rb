class Event < ActiveRecord::Base
  validates :team, :date, presence: true

  belongs_to :team
  has_many :products
  has_many :vendors, through: :products
  has_many :shopping_carts, dependent: :destroy

  scope :past_events, -> { where("date < ?", Time.zone.today) }
  scope :upcoming_events, -> { where("date >= ?", Time.zone.today) }
  scope :today_event, -> { where(date: Time.zone.today) }

  def date_in_words
    return nil if date.blank?
    date.strftime("%B %e, %Y")
  end
end
