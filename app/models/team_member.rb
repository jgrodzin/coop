class TeamMember < ActiveRecord::Base
  validates :team_id, :member_id, presence: true

  belongs_to :member # , inverse_of: :team_member
  belongs_to :team, inverse_of: :team_member
end
