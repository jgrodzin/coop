class TeamMember < ActiveRecord::Base
  validates :team_id, :member_id, presence: true

  belongs_to :member
  belongs_to :team
end
