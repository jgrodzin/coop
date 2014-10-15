#!/usr/bin/env ruby
require "csv"

ENV["RAILS_ENV"] ||= "development"
require File.expand_path("../../config/environment", __FILE__)

def get_first_name(str)
  str || "Unavailable"
end

def get_last_name(str)
  str || "Unavailable"
end

def get_phone(str)
  str || "Unavailable"
end

def get_email(str)
  str || "Unavailable"
end

def get_street_address(str)
  str || "Unavailable"
end

def get_unit_number(str)
  str || " "
end

rows = CSV.read("db/data/products-10-16-14.csv", encoding: "UTF-8")[1..-1]

rows.each_with_index do |row, i|
  row = row.map { |x| x.to_s.strip }

  Product.find_or_create_by(email: get_email(row[3]),
                           first_name: get_first_name(row[0]),
                           last_name: get_last_name(row[1]),
                           phone: get_phone(row[2]),
                           unit_number: get_unit_number(row[5]),

                            )
  puts "importing product: #{i}"
end

puts "*" * 50
puts "Import done!"
puts "Product count: #{Product.count}"
