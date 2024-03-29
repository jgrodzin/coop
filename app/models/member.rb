class Member < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members, inverse_of: :member # team memberships
  has_many :teams, through: :team_members
  has_many :shopping_carts
  has_many :events, through: :teams

  validates :first_name, :last_name, :email, presence: true

  enum status: [:active, :archived, :substitute]
  scope :active_members, -> { where(status: statuses[:active]) }
  scope :archived_members, -> { where(status: statuses[:archived]) }
  scope :substitue_users, -> { where(status: statuses[:substitute]) }

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
    teams.to_a.include?(team)
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

  def active_for_authentication?
    super && (active? || substitute?)
  end

  def destroy_user
    team_members.destroy_all
    shopping_carts.destroy_all
    destroy
  end
end
