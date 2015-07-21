unless Rails.env.production?
  puts "Cleaning database..."
  DatabaseCleaner.clean_with(:truncation)
end

Rake::Task["import:members"].invoke
Rake::Task["import:vendors"].invoke
members = Member.all

puts "seeding teams"
teams = [
  FactoryGirl.create(:team, number: 1),
  FactoryGirl.create(:team, number: 2),
  FactoryGirl.create(:team, number: 3)
]

puts "seeding team_members"
members.each do |member|
  FactoryGirl.create(:team_member, member: member, team: teams.sample)
end

puts "seeding events"
teams.each do |team|
  FactoryGirl.create(:event, team: team, location: members.sample.address)
end

# IMPORT FROM CSV--need event_id
Rake::Task["import:products"].invoke

puts "seeding team_leaders!!"
Event.all.each do |event|
  leader = event.team.team_members.first
  leader.leader = true
  leader.save
end

# puts "seeding shopping_carts"
# members.each do |member|
#   FactoryGirl.create(:shopping_cart, event_id: Event.first.id, member_id: member.id)
# end

mom = Member.find_by(first_name: "Cathy", last_name: "Grodzins")
# mom.admin! # Do this in the member
mom.leader!

Product.all.each do |product|
  product.total_amount_purchased = rand(20)
  product.save
end
