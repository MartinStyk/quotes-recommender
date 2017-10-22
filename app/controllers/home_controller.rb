class HomeController < ApplicationController
  def index
    @quote = InitializeQuote.call(user: current_user).result
    @rating = InitializeRating.call(quote: @quote,
                                    user: current_user).result
  end
end
