# require 'recommender_service'

class AnonymousRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def show_next
    recommend_next
  end

  def recommend_next
    @quote = Quote.offset(rand(Quote.count)).first
  end
end
