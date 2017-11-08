# app/interactors/initialize_rating.rb
class InitializeRating
  include Interactor

  def call
    quote = context.quote
    user = context.user

    if user
      rating = Rating.find_or_initialize_by(quote_id: quote.id,
                                            user_id: user.id)
      # rating adjusted to the range [-2, 2], hence decrement by 3
      # needed to have rating 0 on a scale of [1, 5]
      rating.user_rating = -3 if rating.user_rating.nil?
    else
      rating = Rating.new
      # same as above
      rating.user_rating = -3
    end

    context.result = rating
  end
end
