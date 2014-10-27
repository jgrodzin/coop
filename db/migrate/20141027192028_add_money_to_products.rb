class AddMoneyToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :price, :integer
    add_money :products, :price, currency: { present: false }
  end
end
