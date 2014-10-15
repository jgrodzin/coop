class Member < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates :first_name, :last_name, presence: true

  has_many :team_members
  # belongs_to :team
  has_many :teams, through: :team_members

  def leader?
    team_members.each do |member|
      return member.leader?
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
