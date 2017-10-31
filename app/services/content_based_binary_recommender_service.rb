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

    quotes = Quote.all - @user.viewed_quotes.map(&:quote)

    user_preferred_categories = UserCategoryPreference.where(user_id: @user.id).to_a.map {|cat| [cat.id, cat.preference]}.to_h
    quotes_in_category = Category.all.map {|c| [c.id, c.quotes.size]}.to_h

    size = user_preferred_categories.size
    
    quotes.each do |quote|
      score = 0
      quote_categories_length = quote.categories.length
      quote.categories.each do |category|

        current_category_preference = user_preferred_categories[category.id]
        unless current_category_preference.nil?
          score += current_category_preference * 1/ Math.sqrt(quote_categories_length) *
              Math.log10(quotes_size / quotes_in_category[category.id])
        end

      end
      score_board[quote] = score

    end
    score_board.key(score_board.values.max)

  end
end
