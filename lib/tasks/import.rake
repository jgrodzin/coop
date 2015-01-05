namespace :import do
  require "csv"

  desc "Imports MEMBERS via CSV"
  task :members, [:filename] => :environment do
    # todo -- destructure row to key
    CSV.foreach("db/data/members.csv", headers: true) do |row|
      @member = Member.find_or_create_by(first_name: row[0],
                                         last_name: row[1],
                                         email: row[3],
                                         phone: row[2],
                                         street_address: row[4],
                                         unit_number: row[5],
                                         city: row[6],
                                         state: row[7],
                                         zip: row[8]
                                        )
      @member.password = "password"
      @member.save
    end
    puts "#{Member.count} members imported"
  end

  desc "Imports VENDORS via CSV"
  task :vendors, [:filename] => :environment do
    CSV.foreach("db/data/vendors.csv", headers: true) do |row|
      Vendor.find_or_create_by(name: row[1],
                               rep: row[2],
                               category: row[0],
                               address: row[4],
                               payment: row[7],
                               phone: row[3]
                              )
    end
    puts "#{Vendor.count} vendors imported"
  end

  desc "Imports PRODUCTS via CSV"
  task :products, [:filename] => :environment do
    def get_price(str)
      value = str.blank? ? "$0" : str
      Monetize.extract_cents(value)
    end

    def get_name(str)
      str || "Unavailable"
    end

    def get_price(str)
      value = str.blank? ? "$0" : str
      Monetize.extract_cents(value)
    end

    def get_unit_type(str)
      str || "Other"
    end

    def get_vendor(str)
      vendor = Vendor.find_or_create_by(name: str)
      vendor
    end

    def set_event
      Event.all.sample
    end

    CSV.foreach("db/data/products-10-16-14.csv", headers: true) do |row|
      Product.find_or_create_by(vendor: get_vendor(row[0]),
                                name: get_name(row[1]),
                                price_cents: get_price(row[2]),
                                unit_type: get_unit_type(row[3]),
                                event: set_event
                              )
    end
    puts "#{Product.count} total"
  end
end
