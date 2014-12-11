class Team < ActiveRecord::Base
  # validates :leaders, presence: true

  has_many :team_members
  has_many :members, through: :team_members
  has_many :events

  # scope :leaders, -> (where)

  def leaders
    team_members.where(leader: true).map(&:member).map(&:name)
  end

  def leader_names
    leaders.join(', ')
  end
end
