class HomeController < ApplicationController
  def index
    @quote = RecommendQuote.call(user: current_user).result

    if user_signed_in? && current_user
      @rating = Rating.find_or_initialize_by(quote_id: @quote.id,
                                             user_id: current_user.id)
      if @rating.user_rating.nil?
        @rating.user_rating = 0
      end
    else
      @rating = Rating.new
      @rating.user_rating = 0
    end
  end
end
