class AddTeamId < ActiveRecord::Migration
  def change
    add_column :team_members, :team_id, :integer
  end
end
