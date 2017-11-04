class RandomRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  # Returns random unseen quote
  def recommend_next
      unseen_quotes = Quote.all.pluck(:id) - @user.viewed_quotes.pluck(:quote_id)
      Quote.find unseen_quotes.sample
  end
end
