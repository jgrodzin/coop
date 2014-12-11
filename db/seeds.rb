DatabaseCleaner.clean_with :truncation

require "rake"
%x[rake import:members]
puts "import members: #{Member.count}"

%x[rake import:vendors]
puts "import vendors: #{Vendor.count}"


members = Member.all

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

# need event_id
%x[rake import:products]
puts "import products: #{Product.count}"

puts "seeding team_leaders!!"
Event.all.each do |event|
  leader = event.team.team_members.first
  leader.leader = true
  leader.save
end

puts "seeding events with products..."
Product.all.each do |product|
  product.event = Event.all.sample
  product.save
end

puts "seeding shopping_carts"
members.each do |member|
  FactoryGirl.create(:shopping_cart, event: Event.first, member: member)
end
