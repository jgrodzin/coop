class Team < ActiveRecord::Base
  has_many :team_members
  has_many :members, through: :team_members
  has_many :leaders, through: :team_members, class_name: "Member"

  def leaders
    team_members.where(leader: true)
  end
end
