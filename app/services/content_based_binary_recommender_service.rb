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

    #TODO minus last xxx quotes not all
    quotes = Quote.all - @user.viewed_quotes.map(&:quote)

    quotes.each do |quote|
      score = 0
      quote.categories.each do |category|

        # in case user has a preference for this category, use it
        if UserCategoryPreference.exists?(category_id: category.id, user_id: @user.id)
          score += UserCategoryPreference.find_by(category_id: category.id, user_id: @user.id).preference * 1/ Math.sqrt(quote.categories.length) *
              Math.log10(quotes_size / Category.find(category.id).quotes.size)
        end
      end

      score_board[quote] = score
    end

    score_board.key(score_board.values.max)
  end


end
