class RenameEventProductsToInventories < ActiveRecord::Migration
  def change
    rename_table :event_products, :inventories
  end
end
