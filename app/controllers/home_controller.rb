class HomeController < ApplicationController
  def index
    @quote = Quote.offset(rand(Quote.count)).first
    # Initialize a @rating
    @rating = Rating.new

    # If there is a singed in user, let's create the @rating
    if user_signed_in? && current_user
      @rating = Rating.create!(quote_id: @quote.id,
                               user_id: current_user.id,
                               # Do we need suggested_rating at all?
                               suggested_rating: 3)
      @quote.ratings << @rating
      puts 'rating with id ' + @rating.id.to_s + ' created.'
    end
    @rating
  end
end
