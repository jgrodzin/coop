class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :shopping_cart_id
      t.integer :product_id
      t.money :price_cents
      t.integer :amount

      t.timestamps
    end
  end
end
