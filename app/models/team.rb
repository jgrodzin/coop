class Team < ActiveRecord::Base
  ## validate associated
  has_many :team_members
  accepts_nested_attributes_for :team_members, allow_destroy: true
  has_many :members, through: :team_members
  has_many :events

  scope :all_leaders, -> { TeamMember.joins(:team).where(leader: true) }

  def leaders
    team_members.where(leader: true)
  end

  def leader_names
    leaders.map(&:member).map(&:name).join(", ")
  end

  def team_member_names
    members.includes(:team_memberships).map(&:first_name).join(", ")
  end
end
