class RecommenderService
  def initialize(params)
    @user = params
  end

  def show_next
    @quote = recommend_next
    ViewedQuote.create!(quote_id: @quote.id,
                        user_id: @user.id)
    @quote
  end

  def recommend_next
    raise NotImplementedError
  end
end
