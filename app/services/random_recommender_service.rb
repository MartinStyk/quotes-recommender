# app/services/random_recommender_service.rb
class RandomRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  # Returns random unseen quote
  def recommend_next
    all_quotes = Quote.all.pluck(:id)
    viewed_quotes = @user.viewed_quotes.pluck(:quote_id)
    # Consider all quotes as unseen quotes if the user has already viewed all quotes
    unseen_quotes = (all_quotes - viewed_quotes).empty? ? all_quotes : (all_quotes - viewed_quotes)
    Quote.find unseen_quotes.sample
  end
end
