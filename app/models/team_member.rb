class TeamMember < ActiveRecord::Base
  validates :team_id, :member_id, presence: true
  validates :team_id, uniqueness: { scope: :member, message: "Member is already on this team." }

  belongs_to :member, inverse_of: :team_members
  belongs_to :team, inverse_of: :team_members
end
