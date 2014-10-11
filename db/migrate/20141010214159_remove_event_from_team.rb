class RemoveEventFromTeam < ActiveRecord::Migration
  def change
    remove_column :teams, :event, :integer
  end
end
