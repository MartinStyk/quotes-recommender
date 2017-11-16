# app/services/score_board_recommender_service.rb
class ScoreBoardRecommenderService < RecommenderService

  def initialize(params, show_something_different = false)
    super(params)

    @seen_quotes= @user.viewed_quotes.pluck(:quote_id)
    @all_quotes= Quote.all.pluck(:id)
    @show_something_different = show_something_different
  end

  def show_next
    @quote = choose_next_quote
    ViewedQuote.create(quote_id: @quote.id,
                       user_id: @user.id)
    @quote
  end

  # selects best quote for current user
  # 1. Obtain scoreboard quote.id => score for all considered quotes
  # 2. if @show_something_different is set to false
  #   -Randomize first 30 quotes from scoreboard and return it.
  #    if @show_something_different is set to false
  #   -Select random quote from 30% - 60% best quotes
  #
  # In case score board doesn't contain any results, return random quote
  # returns Quote object which is displayed to user
  def choose_next_quote

    score_board = compute_score_board

    randomize_result score_board

  end

  # builds hash quote.id => quote score based on user preference
  # return scoreboard for all considered quotes, sorted from best fit to worst fit quote
  # meant to be overridden by subclasses
  def compute_score_board
    raise NotImplementedError
  end


  # brings a little randomization to results
  # if @show_something_different is set to false
  #   -return random quote from top 50
  # if @show_something_different is set to false
  #   -Select random quote from 30% - 60% best quotes
  def randomize_result (score_board)
    # if there is no rated unseen quote, return random quote
    # if there is something in our scoreboard, return some quote from top 30 quotes
    if score_board.size == 0 || score_board.values.uniq.length == 1
      unseen_quotes = @all_quotes - @seen_quotes
      return Quote.find unseen_quotes.sample
    end

    if @show_something_different
      lower_bound = (score_board.size * 0.4).round
      upper_bound = (score_board.size * 0.7).round
      Quote.find score_board.keys[rand(lower_bound..upper_bound)]
    else
      lower_bound = 50 < score_board.size ? 50 : score_board.size
      Quote.find score_board.keys[rand(0..lower_bound)]
    end


  end

  # All scores normalized to value (0,1)
  def normalize(score_board)
    max = score_board.values.max
    min = score_board.values.min


    unless max == min
      score_board.each do |key, value|
        score_board[key] = (value - min) / (max - min)
      end
    end
  end
end
