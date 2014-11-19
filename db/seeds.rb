DatabaseCleaner.clean_with :truncation

require "rake"
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

puts "seeding team_leaders!!"
Event.all.each do |event|
  leader = event.team.team_members.first
  leader.leader = true
  leader.save
end

puts "seeding inventories..."
Product.all.each do |product|
  FactoryGirl.create(:inventory, product: product, event: Event.all.sample)
end

puts "seeding shopping_carts"
members.each do |member|
  FactoryGirl.create(:shopping_cart, event: Event.first, member: member)
end
