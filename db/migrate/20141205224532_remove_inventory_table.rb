class RemoveInventoryTable < ActiveRecord::Migration
  def change
    drop_table :inventories
  end
end
