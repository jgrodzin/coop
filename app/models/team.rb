class Team < ActiveRecord::Base
  # validates :leaders, presence: true

  has_many :team_members
  has_many :members, through: :team_members
  has_many :events
  # has_many :leaders, through: :team_members, source: :member?

  def leaders
    team_members.where(leader: true) # .map(&:member)
  end

  def leader_names
    leaders.map(&:member).map(&:name).join(", ")
  end

  def team_member_names
    members.includes(:team_memberships).map(&:first_name).join(", ")
  end
end
