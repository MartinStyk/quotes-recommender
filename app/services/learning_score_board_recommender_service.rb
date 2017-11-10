# app/services/recommender_service.rb
class LearningScoreBoardRecommenderService < ScoreBoardRecommenderService

  def initialize(params)
    super(params)
  end

  # selects best quote for current user
  # 1. Before any recommendations are done, learn user profile. Let user see 10 random quotes
  # 2. Obtain scoreboard quote.id => score for all considered quotes
  # 3. Randomize first 30 quotes from scoreboard and return it.
  #
  # In case score board doesn't contain any results, return random quote
  # returns Quote object which is displayed to user
  def choose_next_quote
    if @seen_quotes.size < 10
      return RandomRecommenderService.new(@user).choose_next_quote
    end

    super
  end
end
