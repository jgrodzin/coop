DatabaseCleaner.clean_with :truncation

puts "seeding events"
events = FactoryGirl.create_list(:event, 5)

puts "seeding members"
members = FactoryGirl.create_list(:member, 20)

puts "seeding vendors"
vendors = FactoryGirl.create_list(:vendor, 12)

puts "seeding products"
products = FactoryGirl.create_list(:product, 10)

puts "seeding teams"
teams = FactoryGirl.create_list(:team, 4)


puts "seeding team_members"
members.each do |member|
  FactoryGirl.create(:team_member, member: member, team: teams.sample)
end

puts "seeding event_products"
products.each do |product|
  FactoryGirl.create(:event_product, product: product, event: events.sample)
end

# ProductCategory.all.each { |category| FactoryGirl.create_list(:product_name, rand(8) + 5, :with_hcpc, :with_products, product_category: category) }
