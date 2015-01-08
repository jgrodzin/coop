class Team < ActiveRecord::Base
  has_many :team_members, inverse_of: :team
  has_many :members, through: :team_members
  # accepts_nested_attributes_for :team_members
  has_many :events
  has_many :leaders, -> { where leader: true }, class_name: TeamMember.name

  scope :all_leaders, -> { TeamMember.joins(:team).where(leader: true) }

  def leader_names
    leaders.map(&:member).map(&:name).join(", ")
  end

  def team_member_names
    members.includes(:team_members).map(&:first_name).join(", ")
  end
end
