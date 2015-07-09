require "csv"

namespace :import do
  task :members, [:filename] => :environment do
    CSV.foreach("db/data/members.csv", headers: true) do |row|
      @member = Member.find_or_create_by(first_name: row["first_name"], last_name: row["last_name"], email: row["email"], phone: row["phone"], street_address: row["street_address"], unit_number: row["unit_number"], city: row["city"], state: row["state"], zip: row["zip"])
      @member.password = "password"
      @member.save
    end

    puts "#{Member.count} members imported"
  end

  task :vendors, [:filename] => :environment do
    CSV.foreach("db/data/vendors.csv", headers: true) do |row|
      Vendor.find_or_create_by(name: row["name"], rep: row["rep"], category: row["category"], address: row["address"], payment: row["payment"], phone: row["phone"])
    end

    puts "#{Vendor.count} vendors imported"
  end

  task :products, [:filename] => :environment do
    def get_vendor(str)
      Vendor.find_or_create_by(name: str)
    end

    def get_price(str)
      value = str.blank? ? "$0" : str
      Monetize.extract_cents(value)
    end

    def get_name(str)
      str || "Unavailable"
    end

    def get_unit_type(str)
      str || "Other"
    end

    def set_event
      Event.all.sample
    end

    files = ["db/data/products-1-29-15.csv", "db/data/products-10-16-14.csv", "db/data/products-12-18-14.csv"]
    files.each do |file|
      CSV.foreach(file, headers: true) do |row|
        Product.find_or_create_by(vendor: get_vendor(row["vendor"]), name: get_name(row["name"]), price_cents: get_price(row["price"]), unit_type: get_unit_type(row["unit type"]), event: set_event)
      end
      puts "Products from #{file.last(12)}"
    end
  end
end
