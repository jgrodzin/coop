class RenamePriceSheetToShoppingCart < ActiveRecord::Migration
  def change
    rename_table :price_sheets, :shopping_carts
  end
end
