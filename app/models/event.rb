class Event < ActiveRecord::Base
  belongs_to :team
  has_many :products
  has_many :vendors, through: :products
  has_many :shopping_carts, dependent: :destroy

  validates :team, :date, presence: true

  scope :past_events, -> { where("date < ?", Time.zone.today) }
  scope :upcoming_events, -> { where("date >= ?", Time.zone.today) }
  scope :today_event, -> { where(date: Time.zone.today) }

  def date_in_words
    return nil if date.blank?
    date.strftime("%B %e, %Y")
  end
end
