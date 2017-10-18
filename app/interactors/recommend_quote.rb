class RecommendQuote
  include Interactor

  def call
    recommend_strategy = nil

    recommend_strategy = if context.user.nil?
                           AnonymousRecommenderService.new(context.user)
                         else
                           RandomRecommenderService.new(context.user)
                         end

    context.result = recommend_strategy.show_next
  end
end
