class ViewedQuotesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    viewed_quotes = ViewedQuote.where(user_id: current_user.id)
    @quote_count_hash = compute_quote_count_hash viewed_quotes

    flash_message = 'Well done! You have already viewed ' + @quote_count_hash.length.to_s + ' unique quotes.'
    flash[:primary] = flash_message if @quote_count_hash.length >= 5
  end

  def filter
    category = Category.find_by_name(filter_params[:name])
    if category.nil?
      @quote_count_hash = {}
      render :index
      return
    end

    quotes = QuoteCategory.where(category_id: category.id)
    viewed_quotes = ViewedQuote.where(user_id: current_user.id,
                                      quote_id: quotes.pluck(:quote_id))
    @quote_count_hash = compute_quote_count_hash viewed_quotes
    render :index
  end

  private

  def filter_params
    params.permit(:name)
  end

  def compute_quote_count_hash(viewed_quotes)
    hash = viewed_quotes.group_by(&:quote_id)
                        .map { |quote_id, quotes| [Quote.find(quote_id), quotes.size] }
                        .to_h
    hash = hash.sort_by { |_k, v| v }.reverse
  end
end
