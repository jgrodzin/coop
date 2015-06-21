#!/usr/bin/env ruby
require "csv"

ENV["RAILS_ENV"] ||= "development"
require File.expand_path("../../config/environment", __FILE__)
require "monetize"

def get_vendor(str)
  vendor = Vendor.find_or_create_by(name: str)
  vendor
end

def get_name(str)
  str || "Unavailable"
end

def get_price(str)
  value = str.blank? ? "$0" : str
  Monetize.extract_cents(value)
end

def get_unit_type(str)
  str || "Unavailable"
end

def get_event_id
  Event.last || 1
end

rows = CSV.read("db/data/products-12-18-14.csv", encoding: "UTF-8")[1..-1]

rows.each_with_index do |row, i|
  row = row.map { |x| x.to_s.strip }

  Product.find_or_create_by(vendor: get_vendor(row[0]),
                            name: get_name(row[1]),
                            price_cents: get_price(row[2]),
                            unit_type: get_unit_type(row[3]),
                            event: get_event_id
                            )
  puts "importing product: #{i}"
end

puts "*" * 50
puts "Import done!"
puts "Product count: #{Product.count}"
