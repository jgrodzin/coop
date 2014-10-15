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

def get_city(str)
  str || "Unavailable"
end

def get_state(str)
  str || "Unavailable"
end

def get_zip(str)
  str || "No zip"
end

def get_password(str)
  str || "password"
end

rows = CSV.read("db/data/members.csv", encoding: "UTF-8")[1..-1]

rows.each_with_index do |row, i|
  row = row.map { |x| x.to_s.strip }

  @member = Member.find_or_create_by(email: get_email(row[3]),
                           first_name: get_first_name(row[0]),
                           last_name: get_last_name(row[1]),
                           phone: get_phone(row[2]),
                           unit_number: get_unit_number(row[5]),
                           city: get_city(row[6]),
                           state: get_state(row[7]),
                           zip: get_zip(row[8]),
                           street_address: get_street_address(row[4])
                            )
  # puts "importing: #{i}, valid: #{@member.valid?}"
  @member.password = "password"
  @member.save
end
puts "*"*50
puts "Import done!"
puts "Member count: #{Member.count}"
