class RenameShoppingCart < ActiveRecord::Migration
  def change
    rename_table :shopping_carts, :price_sheets
  end
end
