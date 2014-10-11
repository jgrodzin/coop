# DatabaseCleaner.clean_with :truncation

puts "import vendors first!"

puts "seeding Products..."
@vendors = Vendor.all
vendor_list = []
@vendors.each do |vendor|
  vendor_list << vendor
  FactoryGirl.create(:product, vendor: vendor_list.sample)
end

puts "seeding members"
members = FactoryGirl.create_list(:member, 20)

puts "seeding teams"
teams = FactoryGirl.create_list(:team, 4) # with members trait

puts "seeding events"
teams.each do |team|
  FactoryGirl.create(:event, team: team)
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

# ProductCategory.all.each { |category| FactoryGirl.create_list(:product_name, rand(8) + 5, :with_hcpc, :with_products, product_category: category) }
