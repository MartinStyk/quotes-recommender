# app/services/global_popularity_recommender_service.rb
class GlobalPopularityRecommenderService < ScoreBoardRecommenderService

  def initialize(params, show_something_different = false)
    super(params, show_something_different)
  end

  # Recommends unseen quotes with best ratings. (sum_ratings / num_ratings)
  def compute_score_board

    # get all rated quotes
    rated_quotes = Rating.all.pluck(:quote_id).uniq

    # consider only unseen quotes
    # array containing data for rating computation [quote_id, sum_of_ratings, number_of_ratings]
    ratings_data = Rating.where(quote_id: rated_quotes - @seen_quotes)
                       .group(:quote_id)
                       .pluck('quote_id, sum(user_rating) AS sum_ratings, count(user_rating) AS count_ratings')

    score_board = {}

    ratings_data.each do |entry|
      score_board[entry[0]] = entry[1] / entry[2]
    end

    score_board
  end
end
