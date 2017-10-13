class RatingController < ApplicationController

  def create
    @quote = Quote.find(params[:id])
    puts quote
    puts current_user.id
    @rating = Rating.create(quote_id: @quote.id, user_id: current_user.id, user_rating: params[:user_rating])
  end

end
