ActiveAdmin.register Product do
  permit_params :name, :unit_type, :price, :vendor_id

  index do
    column :name
    column :unit_type
    column :price
    column :vendor
    actions
  end

  show do |product|
    attributes_table do
      row :name
      row :unit_type
      row :price
      row :vendor_id
    end
  end
end
