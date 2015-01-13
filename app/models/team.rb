class Team < ActiveRecord::Base
  # validates_presence_of :members
  has_many :events
  has_many :team_members, inverse_of: :team
  has_many :members, through: :team_members
  has_many :team_lead_members, -> { where(leader: true) }, class_name: TeamMember.name
  has_many :leaders, through: :team_lead_members, source: :member

  def leader_names
    team_members.where(leader: true).map(&:member).map(&:name).sort.join(", ")
  end

  def team_member_names
    members.includes(:team_members).map(&:first_name).sort.join(", ")
  end
end
