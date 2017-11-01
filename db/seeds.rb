# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

filename = 'data/quotes_filtered.csv'

puts '**  Seeding Database: seeding ***'
puts 'Importing file ' + filename

CSV.foreach(filename, headers: true) do |row|
  categories = []

  # CSV.parse returns array of arrays
  # e.g. [['category1', 'category2']]
  CSV.parse(row.to_h['categories']).first.each do |category|
    categories << Category.find_or_create_by!(name: category)
  end

  quote_hash = Hash['author' => row.to_h['author'],
                    'text' => row.to_h['text'],
                    'categories' => categories]

  Quote.create!(quote_hash)

  # Just to identify progress
  printf("\rParsing line: %d", $INPUT_LINE_NUMBER)
end

puts
puts '**  Seeding Database: completed ***'
