# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

filename = 'data/quotes_filtered_2.csv'

puts '**  Seeding Database: seeding ***'
puts 'Importing file ' + filename

CSV.foreach(filename, headers: true) do |row|
  categories = []

  # CSV.parse returns array of arrays
  # e.g. [['category1', 'category2']]
  CSV.parse(row.to_h['categories']).first.each do |category|
    categories << Category.find_or_create_by!(name: category)
  end

  forbidden = ['a', 'the', 'in', 'on', 'I', 'you', 'we', 'he', 'she', 'it', 'to', 'at', 'is', 'are', 'by', 'of',
  'and', 'or',]

  quote = row.to_h['text']
  quote_words = quote.split.select {|word| !forbidden.include? word.downcase!}

  sum_size = 0
  quote_words.each do |word|
    sum_size += word.size
  end

  quote_hash = Hash['author' => row.to_h['author'],
                    'text' => row.to_h['text'],
                    'categories' => categories,
                    'length' => quote_words.size,
                    'word_avg_length' => sum_size/quote_words.size]

  Quote.create!(quote_hash)

  # Just to identify progress
  printf("\rParsing line: %d", $INPUT_LINE_NUMBER)
end

puts
puts '**  Seeding Database: completed ***'
