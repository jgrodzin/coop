class CreateEventProducts < ActiveRecord::Migration
  def change
    create_table :event_products do |t|
    	t.integer :product_id
    	t.integer :event_id

      t.timestamps
    end
  end
end
