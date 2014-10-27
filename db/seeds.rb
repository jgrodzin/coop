# DatabaseCleaner.clean_with :truncation
# require "scripts/vendor_list"
require 'rake'
%x[rake import:members]
puts "import members: #{Member.count}"

%x[rake import:vendors]
puts "import vendors: #{Vendor.count}"

%x[rake import:products]
puts "import products: #{Product.count}"

members = Member.all
# products = Product.all
# vendors = Vendor.all

puts "seeding teams"
teams = FactoryGirl.create_list(:team, 4) # with members trait

puts "seeding team_members"
members.each do |member|
  FactoryGirl.create(:team_member, member: member, team: teams.sample)
end

puts "seeding events"
teams.each do |team|
  FactoryGirl.create(:event, team: team, location: members.sample.address)
end


puts "seeding event_products"
Product.all.each do |product|
  FactoryGirl.create(:event_product, product: product, event: Event.all.sample)
end

puts "seeding price_sheets"
members.each do |member|
  FactoryGirl.create(:price_sheet, event: Event.first, member: member)
end
