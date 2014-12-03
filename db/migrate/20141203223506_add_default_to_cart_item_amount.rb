class AddDefaultToCartItemAmount < ActiveRecord::Migration
  def change
    change_column_default(:cart_items, :amount, 1)
  end
end
