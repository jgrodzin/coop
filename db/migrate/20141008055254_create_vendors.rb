class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
    	t.string :rep
    	t.string :name
    	t.string :category
    	t.string :address
    	t.string :payment

      t.timestamps
    end
  end
end
