# DatabaseCleaner.clean_with :truncation
# require "scripts/vendor_list"

puts "import vendors first!"

puts "seeding Products..."
@vendors = Vendor.all
vendor_list = []
@vendors.each do |vendor|
  vendor_list << vendor
  FactoryGirl.create(:product, vendor: vendor_list.sample)
end

# puts "seeding members"
# members = FactoryGirl.create_list(:member, 20)

members = Member.all
# products = Product.all

puts "seeding teams"
teams = FactoryGirl.create_list(:team, 4) # with members trait

puts "seeding events"
teams.each do |team|
  FactoryGirl.create(:event, team: team, location: members.sample.address)
end

# puts "seeding products"
# products = FactoryGirl.create_list(:product, 10)

puts "seeding team_members"
members.each do |member|
  FactoryGirl.create(:team_member, member: member, team: teams.sample)
end

puts "seeding event_products"
Product.all.each do |product|
  FactoryGirl.create(:event_product, product: product, event: Event.all.sample)
end

puts "seeding price_sheets"
members.each do |member|
  FactoryGirl.create(:price_sheet, event: Event.first, member: member)
end
