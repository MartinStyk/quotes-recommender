class HomeController < ApplicationController
  def index
    @quote = RecommendQuote.call(user: current_user).result
    @rating = InitializeRating.call(quote: @quote,
                                    user: current_user).result
  end
end
