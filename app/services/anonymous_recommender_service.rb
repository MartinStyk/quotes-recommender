# app/services/anonymous_recommender_service.rb
class AnonymousRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def show_next
    @quote = Quote.all.sample
  end

end
