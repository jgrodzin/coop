class AddDefaultToProductAmount < ActiveRecord::Migration
  def change
    change_column_default :products, :total_amount_purchased, 0
  end
end
