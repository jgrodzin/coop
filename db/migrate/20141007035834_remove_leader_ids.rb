class RemoveLeaderIds < ActiveRecord::Migration
  def change
    remove_column :team_members, :leader_id
  end
end
