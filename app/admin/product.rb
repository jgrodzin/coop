ActiveAdmin.register Product do
  permit_params :name, :description, :price, :vendor_id

  index do
    column :name
    column :description
    column :price
    column :vendor
    actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :vendor_id
    end
  end
end
