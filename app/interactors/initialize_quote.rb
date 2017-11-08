# app/interactors/initialize_quote.rb
class InitializeQuote
  include Interactor

  def call
    user = context.user

    quote = if Quote.all.blank?
              Quote.new
            else
              RecommendQuote.call(user: user).result
            end

    context.result = quote
  end
end
