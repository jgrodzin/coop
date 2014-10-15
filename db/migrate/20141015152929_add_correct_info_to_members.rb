class AddCorrectInfoToMembers < ActiveRecord::Migration
  def change
    add_column :members, :phone, :string
    add_column :members, :unit_number, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :zip, :integer
    add_column :members, :street_address, :string
    remove_column :members, :address
  end
end
