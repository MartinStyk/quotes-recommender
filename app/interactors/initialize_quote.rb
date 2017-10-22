class InitializeQuote
  include Interactor

  def call
    user = context.user

    if Quote.all.blank?
      quote = Quote.new
    else
      quote = RecommendQuote.call(user: user).result
    end

    context.result = quote
  end
end
