class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:about]

  def index
    show_different = !recommend_params[:different].nil? && recommend_params[:different]

    selected_category = !recommend_params[:category].nil? && recommend_params[:category]

    if selected_category
      @quote = Category.find(selected_category).quotes.sample
    else
      @quote = InitializeQuote.call(user: current_user, show_different: show_different).result
    end

    @rating = InitializeRating.call(quote: @quote,
                                    user: current_user).result


  end

  def welcome
    @categories = Category.all.shuffle.first(8)
  end

  def about
  end

  def recommend_params
    params.permit(:different, :category)
  end
end
