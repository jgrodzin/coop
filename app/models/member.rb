class Member < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates :first_name, :last_name, presence: true

  has_many :team_members
  has_many :teams, through: :team_members
  has_many :price_sheets

  def leader?
    team_members.each do |member|
      return member.leader?
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def address
    if unit_number.present?
      "#{street_address}, #{unit_number}, #{city}, #{state}, #{zip}"
    else
      "#{street_address}, #{city}, #{state}, #{zip}"
    end
  end
end
