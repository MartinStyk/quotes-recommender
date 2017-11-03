class GlobalPopularityRecommenderService < RecommenderService

  def initialize(params)
    super(params)
  end


  # Recommends unseen quotes with best ratings. (sum_ratings / num_ratings)
  #
  # If there is no unseen rated quote, return random unseen quote
  #
  def recommend_next
    # quotes seen by user
    seen_quotes = @user.viewed_quotes.pluck(:quote_id)

    # get all rated quotes
    rated_quotes = Rating.all.pluck('DISTINCT quote_id')

    # consider only unseen quotes
    # array containing data for rating computation [quote_id, sum_of_ratings, number_of_ratings]
    ratings_data = Rating.where(quote_id: rated_quotes - seen_quotes)
                       .group(:quote_id)
                       .pluck("quote_id, sum(user_rating) AS sum_ratings, count(user_rating) AS count_ratings")

    score_board = {}

    # TODO consider number of ratings
    # TODO in case we do not need to consider number of ratings this can be done by single DB query ^
    ratings_data.each do |entry|
      score_board[entry[0]] = entry[1] / entry[2]
    end

    # choose the best quote to display
    best_quote_id = score_board.key(score_board.values.max)

    # if there is no rated unseen quote, return random quote
    # if there is something in our scoreboard, return best rated unseen quote
    if best_quote_id.nil?
      unseen_quotes = Quote.all.pluck(:id) - seen_quotes
      Quote.find unseen_quotes.sample
    else
      Quote.find best_quote_id
    end

  end
end
