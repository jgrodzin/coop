class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :member_id
      t.integer :leader_id
      t.boolean :leader, default: false

      t.timestamps
    end
  end
end
