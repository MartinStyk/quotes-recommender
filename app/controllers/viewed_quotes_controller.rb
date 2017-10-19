class ViewedQuotesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    viewed_quotes = ViewedQuote.where(user_id: current_user.id)
    @quotes = viewed_quotes.map(&:quote)
  end
end
