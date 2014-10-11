ActiveAdmin.register Member do
  permit_params :email, :password, :first_name, :last_name

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    actions
  end

  filter :email
  filter :first_name
  filter :last_name

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end

end
