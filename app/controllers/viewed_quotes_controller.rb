class ViewedQuotesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    viewed_quotes = ViewedQuote.where(user_id: current_user.id)
    @quote_count_hash = viewed_quotes.group_by(&:quote_id)
                                     .map { |quote_id, quotes| [Quote.find(quote_id), quotes.size] }.to_h
  end
end
