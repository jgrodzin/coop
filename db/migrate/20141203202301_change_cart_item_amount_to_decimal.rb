class ChangeCartItemAmountToDecimal < ActiveRecord::Migration
  def change
    change_column :cart_items, :amount, :decimal
  end
end
