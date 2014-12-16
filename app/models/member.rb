class Member < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, presence: true

  has_many :team_memberships, class_name: "TeamMember"
  has_many :teams, through: :team_memberships
  has_many :shopping_carts
  has_many :events, through: :teams

  def admin!
    update_attribute :admin, true
  end

  def leader?
    team_memberships.each do |team_member|
      return team_member.leader?
    end
  end

  def leader!
    team_memberships.each do |team_member|
      team_member.leader = true
      team_member.save
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def address
    if unit_number.present?
      "#{street_address}, #{unit_number}, #{city}, #{state} #{zip}"
    else
      "#{street_address}, #{city}, #{state} #{zip}"
    end
  end
end
