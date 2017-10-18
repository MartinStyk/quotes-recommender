# require 'recommender_service'

class RandomRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def recommend_next
    # TODO
    @quote = Quote.offset(rand(Quote.count)).first
  end
end
