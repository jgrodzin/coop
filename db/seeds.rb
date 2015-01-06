DatabaseCleaner.clean_with :truncation
require "rake"

# call db:seed task
system("rake import:members")
system("rake import:vendors")
# %x[rake import:vendors]

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
system("rake import:products")

puts "seeding team_leaders!!"
Event.all.each do |event|
  leader = event.team.team_members.first
  leader.leader = true
  leader.save
end

puts "seeding shopping_carts"
members.each do |member|
  FactoryGirl.create(:shopping_cart, event: Event.first, member: member)
end

mom = Member.find_by(first_name: "Cathy", last_name: "Grodzins")
mom.admin!
mom.leader!
