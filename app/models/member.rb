class Member < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, presence: true

  has_many :team_members, inverse_of: :member
  has_many :teams, through: :team_members
  has_many :shopping_carts
  has_many :events, through: :teams

  def admin!
    update_attribute :admin, true
  end

  def leader?
    team_members.each do |team_member|
      return team_member.leader?
    end
  end

  def leader!
    team_members.each do |team_member|
      team_member.leader = true
      team_member.save
    end
  end

  def on_team?(team)
    teams.include?(team)
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

  def format_name_with_leader
    if leader? == true
      "#{first_name} (leader)"
    else
      "#{first_name}"
    end
  end
end
