class Team < ActiveRecord::Base
  # validates :leaders, presence: true

  has_many :team_members
  has_many :members, through: :team_members
  has_many :leaders, through: :team_members, class_name: "Member"

  has_many :events

  def leaders
    team_members.where(leader: true)
  end
end
