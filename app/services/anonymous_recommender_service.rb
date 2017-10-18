# require 'recommender_service'

class AnonymousRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def show_next
    recommend_next
  end

  def recommend_next
    # TODO
    @quote = Quote.all.first
  end
end
