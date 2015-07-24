class Team < ActiveRecord::Base
  has_many :events
  has_many :team_members, inverse_of: :team
  has_many :members, through: :team_members
  has_many :team_lead_members, -> { where(leader: true) }, class_name: TeamMember.name
  has_many :leaders, through: :team_lead_members, source: :member

  validates_presence_of :members

  def leader_names
    team_members.includes(:member).where(leader: true).map(&:member).map(&:name).sort.join(", ")
  end

  def team_member_names
    members.map(&:first_name).sort.join(", ")
  end

  def team_with_name_and_number
    "Team #{number}: #{team_member_names}"
  end
end
