# require 'recommender_service'

class ContentBasedBinaryRecommenderService < RecommenderService

  def initialize(params)
    super(params)
  end


  # Create score board of all quotes available to recommend
  #
  # For each quote we compute probability that user will like it. We do this based on user's  category preferences and categories of quotes
  # User category preferences are computed when he enters rating in RatingsController.
  #
  # Rating of a quote is computed as a sum of (category_preference * 1/sqrt(#categories_of_quote)) * IDF.
  #
  # IDF = log_10 (number of all quotes / DF), where DF is number of quotes in given category
  #
  # Quote with highest score is returned. If there is no rated quote, random is returned
  #
  # TODO even bad rated category is currently better than non rated category
  # TODO consider normalizing user category preference? smthng like category_preference - average_user_category_preference?
  # TODO Normalized preference is updated with every user rating - it should not be stored in DB in RatingsController, I would
  # TODO rather compute it right here
  # TODO another option is to consider 1* as -2,...., 5* as +2 and we are done with this issue - this needs to be implemented
  # TODO ratings controller on user preferred category save
  def recommend_next

    # quote.id -> expectation on how much user likes this quote
    score_board = Hash.new

    # number of all quotes in DB
    size_all_quotes = Quote.all.size

    # ids of all quotes current user has already seen
    user_viewed_quotes = @user.viewed_quotes.pluck(:quote_id)

    # categories user have already seen and rated quotes in them
    # category.id -> users preference for category
    user_preferred_categories = UserCategoryPreference.where(user_id: @user.id).pluck(:category_id, :preference).to_h

    # mapping from categories user has already rated to all quotes in given category
    # category.id -> ids of all quotes in given category
    quotes_in_category = quotes_by_categories user_preferred_categories

    # quote.id -> number of categories quote belongs to
    categories_of_quote = QuoteCategory.where(quote_id: QuoteCategory.where(category_id: user_preferred_categories.keys)
                            .map {|quote_categeory| quote_categeory.quote_id})
                            .group(:quote_id).count


    # for each quote which belongs to categories user has already preference, and user has not seen it before
    # compute quote ranking as a sum through all categories of (quote_in_category_ratio * user_preference_for_given_category * IDF)

    user_preferred_categories.each do |category_id, category_preference|

      # we recommend only unseen quotes
      quotes_in_current_category = quotes_in_category[category_id]
      considered_quotes = quotes_in_current_category - user_viewed_quotes

      considered_quotes.each do |quote|
        if score_board[quote].nil?
          score_board[quote] = 0
        end

        score_board[quote] +=
            category_preference * 1 / Math.sqrt(categories_of_quote[quote]) *
            Math.log10(size_all_quotes / quotes_in_current_category.size)
      end
    end

    # choose the best quote to display
    best_quote_id = score_board.key(score_board.values.max)

    # if we dont know users preference, return random quote
    # this happens when there is no quote rating
    if best_quote_id.nil?
      best_quote_id = Quote.offset(rand(Quote.count)).first
    end

    # return the result quote
    Quote.find best_quote_id

    # quotes.each do |quote|
    #   score = 0
    #   quote_categories_length = quote.categories.length
    #   quote.categories.each do |category|
    #
    #     current_category_preference = user_preferred_categories[category.id]
    #     unless current_category_preference.nil?
    #       score += current_category_preference * 1/ Math.sqrt(quote_categories_length) *
    #           Math.log10(quotes_size / quotes_in_category[category.id])
    #     end
    #
    #   end
    #   score_board[quote] = score
    #
    # end

  end

  :private

  def quotes_by_categories(user_preferred_categories)
    category_quotes_temp = QuoteCategory.where(category_id: user_preferred_categories.keys).pluck(:category_id, :quote_id)
    category_quotes = {}

    category_quotes_temp.each do |category_id, quote_id|
      if category_quotes[category_id].nil?
        category_quotes[category_id] = []
      end
      category_quotes[category_id] << quote_id
    end
  end


end
