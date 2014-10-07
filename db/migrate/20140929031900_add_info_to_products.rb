class AddInfoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :name, :string
    add_column :products, :price, :integer
    add_column :products, :description, :text
    add_column :products, :vendor_id, :integer
  end
end
