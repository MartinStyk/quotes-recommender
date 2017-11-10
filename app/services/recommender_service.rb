# app/services/recommender_service.rb
class RecommenderService
  def initialize(params)
    @user = params
  end

  def show_next
    @quote = choose_next_quote
    ViewedQuote.create(quote_id: @quote.id,
                       user_id: @user.id)
    @quote
  end

  # selects best quote for current user
  # meant to be overridden by subclasses
  def choose_next_quote
    raise NotImplementedError
  end
end
