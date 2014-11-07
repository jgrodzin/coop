class AddInfoToShoppingCart < ActiveRecord::Migration
  def change
    add_money :shopping_carts, :sub_total, currency: { present: false }, amount: { null: true, default: nil }
    add_money :shopping_carts, :total, currency: { present: false }
  end
end
