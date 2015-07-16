class AddStatusToMember < ActiveRecord::Migration
  def change
    add_column :members, :status, :integer, default: 0
  end
end
