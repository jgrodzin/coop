class AddNotesToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :notes, :text
  end
end
