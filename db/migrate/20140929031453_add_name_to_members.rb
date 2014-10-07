class AddNameToMembers < ActiveRecord::Migration
  def change
    add_column :members, :first_name, :string
    add_column :members, :last_name, :string
    add_column :members, :address, :string
  end
end
