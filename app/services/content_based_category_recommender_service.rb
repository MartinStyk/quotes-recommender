# app/services/content_based_binary_recommender_service.rb
class ContentBasedCategoryRecommenderService < LearningScoreBoardRecommenderService

  def initialize(params, show_something_different = false)
    super(params, show_something_different)
  end

  # Create score board of all quotes available to recommend
  #
  # For each quote we compute probability that user will like it. We do this based on user's  category preferences and categories of quotes
  # User category preferences are computed when he enters rating in RatingsController.
  #
  # Rating of a quote is computed as a sum of (category_preference * 1/sqrt(#categories_of_quote)) * IDF.
  #
  # IDF = log_10 (number of all quotes / DF), where DF is number of quotes in given category
  def compute_score_board
    # quote.id -> expectation on how much user likes this quote
    score_board = {}

    # number of all quotes in DB
    size_all_quotes = @all_quotes.size

    # categories user have already seen and rated quotes in them
    # category.id -> users preference for category
    user_preferred_categories = UserCategoryPreference.where(user_id: @user.id)
                                                      .pluck(:category_id, :preference)
                                                      .to_h

    # mapping from categories user has already rated to all quotes in given category
    # category.id -> ids of all quotes in given category
    quotes_in_category = quotes_by_categories user_preferred_categories

    # quote.id -> number of categories quote belongs to
    categories_of_quote = QuoteCategory.where(quote_id: QuoteCategory.where(category_id: user_preferred_categories.keys)
                                                                     .pluck(:quote_id))
                                       .group(:quote_id)
                                       .count
    # init scoreboard
    (@all_quotes - @seen_quotes).each do |quote_id|
      score_board[quote_id] = 0
    end

    # for each quote which belongs to categories user has already preference, and user has not seen it before
    # compute quote ranking as a sum through all categories of (quote_in_category_ratio * user_preference_for_given_category * IDF)
    user_preferred_categories.each do |category_id, category_preference|
      # we recommend only unseen quotes
      quotes_in_current_category = quotes_in_category[category_id]
      considered_quotes = quotes_in_current_category - @seen_quotes

      considered_quotes.each do |quote|
        score_board[quote] +=
          category_preference * 1 / Math.sqrt(categories_of_quote[quote]) *
          Math.log10(size_all_quotes / quotes_in_current_category.size)
      end
    end

    normalize score_board
    score_board.sort_by {|key, value| value}.reverse.to_h
  end

  private

  # parameter: user_preferred_categories
  # format: {cat_id => cat_preference}
  # example: {5=>0.5, 6=>0.5, 7=>0.5, 8=>0.5}
  def quotes_by_categories(user_preferred_categories)
    category_quotes_temp = QuoteCategory.where(category_id: user_preferred_categories.keys)
                                        .group_by(&:category_id)

    category_quotes = {}

    category_quotes_temp.each do |category_id, quote_category_object|
      category_quotes[category_id] = quote_category_object.pluck(:quote_id)
    end

    # return
    # format: {cat_id => [q1_id,..,qn_id]}
    category_quotes
  end
end
