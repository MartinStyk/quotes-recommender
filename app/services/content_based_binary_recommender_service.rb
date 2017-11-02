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
  # Rating of a quote is computed as a sum of (category_preference * 1/sqrt(#categoriesofquote)) * IDF.
  #
  # IDF = log_10 (number of all quotes / DF), where DF is number of quotes in given category
  #
  # Quote with highest score is returned
  #
  # TODO even bad rated category is currently better than non rated category
  # TODO consider normalizing user category preference? smthng like category_preference - average_user_category_preference?
  # TODO Normalized preference is updated with every user rating - it should not be stored in DB in RatingsController, I would
  # TODO rather compute it right here
  # TODO another option is to consider 1* as -2,...., 5* as +2 and we are done with this issue - this needs to be implemented
  # TODO ratings controller on user preferred category save
  def recommend_next

    quotes_size = Quote.all.size

    score_board = Hash.new

    # consider only unseen quotes
    user_viewed_quotes = @user.viewed_quotes.map(&:quote)

    # categories user have already seen and rated quotes in them
    user_preferred_categories = UserCategoryPreference.where(user_id: @user.id).to_a.map {|cat| [cat.id, cat.preference]}.to_h

    # mapping category -> all quotes in categories, for performance reasons we need this only for quotes already rated by user
    category_quotes = Category.where(:id => user_preferred_categories.keys).map {|c| [c.id, c.quotes.to_a]}.to_h

    # TODO based on join table get mapping quote -> number of quote categories
    # mapping category -> all quotes in categories, for performance reasons we need this only for quotes already rated by user
    #quotes_categories = Quote.where(:categories => UserCategoryPreference.where(user_id: @user.id).map(&:category)).map {|c| [c.id, c.quotes.to_a]}.to_h

    # for each quote which belongs to categories user has already preference, and user has not seen the
    # quote before, compute quote ranking as a sum(quote_in_category_ratio * user_preference_for_given_category * IDF)
    user_preferred_categories.each do |cat_id, cat_preference|
      quotes_in_category = category_quotes[cat_id]
      considered_quotes = quotes_in_category - user_viewed_quotes
      considered_quotes.each do |quote|
        if score_board[quote].nil?
          score_board[quote] = 0
        end

        cat_count = QuoteCategory.where(quote_id: quote.id).count
        score_board[quote] += cat_preference * 1 / Math.sqrt(cat_count) *
            Math.log10(quotes_size / quotes_in_category.size)
      end
    end

    # choose the best one
    best_quote = score_board.key(score_board.values.max)

    # if there are no preferred categories (no ratings) yet for the user
    # we have to return a random quote
    return (Quote.all - user_viewed_quotes).sample if best_quote.nil?
    # otherwise return the best quote
    best_quote

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
end
