class RemoveTeamFromMember < ActiveRecord::Migration
  def change
    remove_column :members, :team_id
  end
end
