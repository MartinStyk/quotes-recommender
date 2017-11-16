# app/services/learning_score_board_recommender_service.rb
class LearningScoreBoardRecommenderService < ScoreBoardRecommenderService

  def initialize(params, show_something_different = false)
    super(params, show_something_different)
  end

  # selects best quote for current user
  # 1. Before any recommendations are done, learn user profile. Let user see 5 random quotes
  # 2. Obtain scoreboard quote.id => score for all considered quotes
  # 3. if @show_something_different is set to false
  #   -Randomize first 50 quotes from scoreboard and return it.
  #    if @show_something_different is set to false
  #   -Select random quote from 30% - 60% best quotes
  #
  # In case score board doesn't contain any results, return random quote
  # returns Quote object which is displayed to user
  def choose_next_quote
    if @seen_quotes.size < 5
      return RandomRecommenderService.new(@user).choose_next_quote
    end

    super
  end
end
