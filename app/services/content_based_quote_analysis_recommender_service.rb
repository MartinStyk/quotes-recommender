# app/services/content_based_binary_recommender_service.rb
class ContentBasedQuoteAnalysisRecommenderService < RecommenderService
  def initialize(params)
    super(params)
  end

  def recommend_next
    # quote.id -> expectation on how much user likes this quote
    score_board = {}

    # all quotes
    all_quotes = Quote.all.to_a

    # ids of all quotes current user has already seen
    user_viewed_quotes = @user.viewed_quotes.to_a

    # length -> users preference for given length
    user_preferred_quote_lengths = UserQuoteLengthPreference.where(user_id: @user.id)
                                                      .pluck(:length, :preference)
                                                      .to_h
    # length -> number quotes of given length
    quotes_by_quote_length = Quote.group(:length).count

    # word_avg_length -> users preference for given word_avg_length
    user_preferred_word_lengths = UserWordLengthPreference.where(user_id: @user.id)
                                        .pluck(:length, :preference)
                                        .to_h
    # word_avg_length -> number quotes of given length
    quotes_by_word_avg_length = Quote.group(:word_avg_length).count

    (all_quotes - user_viewed_quotes).each do |quote|
      score_board[quote] = 0 if score_board[quote].nil?
      # sum of preference * IDF for both quote length and avg word length
      score_board[quote] += user_preferred_quote_lengths.fetch(quote.length, 0) *
          Math.log10(all_quotes.size / quotes_by_quote_length[quote.length]) +
         user_preferred_word_lengths.fetch(quote.word_avg_length, 0) *
          Math.log10(all_quotes.size / quotes_by_word_avg_length[quote.word_avg_length])
    end

    # choose the best quote to display
    best_quote = if !score_board.empty? && score_board.values.max > 0
                      score_board.key(score_board.values.max)
                    end

    # if we dont know users preference, return random unseen quote
    # this happens when there is no quote rating or no unseen quote
    if best_quote.nil?
      all_quotes = Quote.all.pluck(:id)
      # Consider all quotes as unseen quotes if the user has already viewed all quotes
      unseen_quotes = (all_quotes - user_viewed_quotes).empty? ? all_quotes : (all_quotes - user_viewed_quotes)
      Quote.find unseen_quotes.sample
    else
      # return best result
      best_quote
    end
  end
end
