class AddUnitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :unit_type, :string
    remove_column :products, :description, :string
  end
end
