class RemovePriceCentsFromCartItem < ActiveRecord::Migration
  def change
    remove_column :cart_items, :price_cents, :integer
    remove_column :cart_items, :price_cents_currency, :string
  end
end
