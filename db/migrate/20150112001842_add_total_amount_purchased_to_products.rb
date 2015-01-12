class AddTotalAmountPurchasedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :total_amount_purchased, :integer
  end
end
