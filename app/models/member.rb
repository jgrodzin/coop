class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  # belongs_to :team
  has_many :teams, through: :team_members

  def leader?
    team_members.each do |member|
      return member.leader?
    end
  end
end
