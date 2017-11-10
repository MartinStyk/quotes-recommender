class HomeController < ApplicationController
  def index

    show_different = !recommend_params[:different].nil? && recommend_params[:different]

    @quote = InitializeQuote.call(user: current_user, show_different: show_different).result
    @rating = InitializeRating.call(quote: @quote,
                                    user: current_user).result



  end

  def recommend_params
    params.permit(:different)
  end
end
