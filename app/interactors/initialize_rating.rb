class InitializeRating
  include Interactor

  def call
    quote = context.quote
    user = context.user

    if user
      rating = Rating.find_or_initialize_by(quote_id: quote.id,
                                            user_id: user.id)
      rating.user_rating = 0 if rating.user_rating.nil?
    else
      rating = Rating.new
      rating.user_rating = 0
    end

    context.result = rating
  end
end
