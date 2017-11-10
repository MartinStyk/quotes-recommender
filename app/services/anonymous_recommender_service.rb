# app/services/anonymous_recommender_service.rb
class AnonymousRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def show_next
    choose_next_quote
  end

  def choose_next_quote
    @quote = Quote.all.first
  end
end
