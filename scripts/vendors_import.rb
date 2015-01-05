# #!/usr/bin/env ruby
# require "csv"

# ENV["RAILS_ENV"] ||= "development"
# require File.expand_path("../../config/environment", __FILE__)

# def get_name(str)
#   str || "Unavailable"
# end

# def get_rep(str)
#   str || "Unavailable"
# end

# def get_category(str)
#   str || "Unavailable"
# end

# def get_phone(str)
#   str || "Unavailable"
# end

# def get_address(str)
#   str || "Unavailable"
# end

# def get_payment(str)
#   str || "Unavailable"
# end

# rows = CSV.read("db/data/vendors.csv", encoding: "UTF-8")[1..-1]

# rows.each_with_index do |row, i|
#   row = row.map { |x| x.to_s.strip }

#   Vendor.find_or_create_by(name: get_name(row[1]),
#                            rep: get_rep(row[2]),
#                            category: get_category(row[0]),
#                            address: get_address(row[4]),
#                            payment: get_payment(row[7]),
#                            phone: get_phone(row[3])
#                             )
#   puts "importing #{i} vendors"
# end

# puts "Import done!"
