ActiveAdmin.register Team do
  permit_params :name, :theme, :team_members, :members

  index do
    column :name
    column :theme
    column "Members" do |team|
      team.members.map(&:first_name).join(", ")
    end
  end
  # show do |team|
  #   attributes_table do
  #     row :name
  #     row :theme
  #   end
  # end

  show do
    attributes_table do
      row :name
    end
    panel "Team Members" do
      table_for team.members do
        column "Member Name" do |member|
          link_to "#{member.first_name}", admin_member_path(member)
        end
        column "Member ID" do |member|
          member.id
        end
        column "Responsibilities" do

        end
      end
    end
  end

end
