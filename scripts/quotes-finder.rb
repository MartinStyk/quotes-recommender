require 'net/http'
require 'json'
require 'set'
require 'csv'

class Quote
  attr_reader :text
  attr_reader :author

  def initialize(text, author)
    @text = text
    @author = author
  end

  def to_str
    to_s
  end

  def to_s
    @text + '(' + @author + ')'
  end

  def ==(other)
    other.class == self.class && other.state == state
  end

  def eql?(other)
    other.class == self.class && other.state == state
  end

  def hash
    state.hash
  end

  protected

  def state
    [@text, @author]
  end
end

quotes = Set.new

while quotes.size != 1800

  # Get quote from public rest API. Use key request parameter to get random quotes
  url = 'http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en&key=' + 6.times.map { rand(10) }.join
  uri = URI(url)
  response = Net::HTTP.get(uri)

  # When response contains unescaped characters, we are unable to parse it.
  begin
    json = JSON.parse(response)
  rescue
    puts 'Unable to parse response ' + response
    next
  end

  quote = Quote.new(json['quoteText'], json['quoteAuthor'])
  quotes.add(quote)

  puts quotes.size
end

CSV.open('quotes.csv', 'wb') do |csv|
  csv << %w[text author]
  quotes.each do |q|
    csv << [q.text, q.author]
  end
end
