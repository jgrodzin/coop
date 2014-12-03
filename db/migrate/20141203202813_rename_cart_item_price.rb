class RenameCartItemPrice < ActiveRecord::Migration
  def change
    remove_column :cart_items, :price_cents_cents
    add_money :cart_items, :price, currency: { present: false }
  end
end
