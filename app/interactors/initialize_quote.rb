# app/interactors/initialize_quote.rb
class InitializeQuote
  include Interactor

  def call
    user = context.user
    show_different = context.show_different

    quote = if Quote.all.blank?
              Quote.new
            else
              RecommendQuote.call(user: user, show_different: show_different).result
            end

    context.result = quote
  end
end
