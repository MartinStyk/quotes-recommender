# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

filename = 'data/quotes_sample.csv'

puts '**  Seeding Database: seeding ***'
puts 'Importing file ' + filename

CSV.foreach(filename, headers: true) do |row|
  Quote.create!(row.to_h)
end

puts '**  Seeding Database: completed ***'
