class RemoveAdminsTable < ActiveRecord::Migration
  def change
    drop_table :admins
  end
end
