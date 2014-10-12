ActiveAdmin.register Vendor do
  permit_params :name, :rep, :category, :phone_number, :address, :payment

  # index do
  #   column :name
  #   column :rep
  #   column :category
  #   column :phone_number
  #   actions
  # end

  index as: :grid do |vendor|
    link_to((vendor.name), admin_vendor_path(vendor))
  end

  # index as: :block do |vendor|
  #   div for: vendor do
  #     h2 auto_link(vendor.name)
  #     div do
  #       simple_format vendor.category
  #     end
  #   end
  # end

  show do |vendor|
    attributes_table do
      row :name
      row :rep
      row :category
      row :address
      row :phone_number
      row :paynment
    end
  end
end
