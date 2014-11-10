class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :shopping_cart_id
      t.integer :quantity
      t.money  :unit_price
      t.money :total_price

      t.timestamps
    end
  end
end
