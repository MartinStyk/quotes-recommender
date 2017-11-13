# app/services/content_based_mixed_recommender_service.rb
class ContentBasedMixedRecommenderService < LearningScoreBoardRecommenderService

  def initialize(params, show_something_different = false)
    super(params, show_something_different)
  end

  # Recommendation based on number of words and length of words of quotean quote categories
  #
  # User profile for these attributes is computed in RatingsController
  #
  # Build score board of all quotes based on these attributes.
  #
  # Final score of quote is weighted  4:1 for category recommendation
  def compute_score_board
    score_board_quote_analysis = ContentBasedQuoteAnalysisRecommenderService.new(@user).compute_score_board
    score_board_category_analysis = ContentBasedCategoryRecommenderService.new(@user).compute_score_board

    merged_score_board = score_board_quote_analysis.merge(score_board_category_analysis) {|quote, score_quote, score_category| 0.2 * score_quote + 0.8 * score_category}
    merged_score_board.sort_by {|key, value| value}.reverse.to_h
  end

end
