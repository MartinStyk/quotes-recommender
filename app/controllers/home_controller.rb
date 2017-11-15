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
    @category1 = Category.find(rand(Category.count) + 1)
    @category2 = Category.find(rand(Category.count) + 1)
    @category3 = Category.find(rand(Category.count) + 1)
    @category4 = Category.find(rand(Category.count) + 1)
    @category5 = Category.find(rand(Category.count) + 1)
    @category6 = Category.find(rand(Category.count) + 1)
  end

  def about
  end

  def recommend_params
    params.permit(:different, :category)
  end
end
