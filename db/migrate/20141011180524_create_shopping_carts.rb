class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.integer :member_id
      t.integer :event_id

      t.timestamps
    end
  end
end
