class ChangeCartItemDefault < ActiveRecord::Migration
  def change
    change_column :cart_items, :amount, :decimal, default: 0.0
  end
end
