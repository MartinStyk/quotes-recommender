class Quote < ApplicationRecord
  require 'csv'

  filename = 'data/quotes_sample.csv'

  CSV.foreach(filename, headers: true) do |row|
    Quote.create!(row.to_h)
  end
end
