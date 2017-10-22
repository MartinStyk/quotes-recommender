class RecommendQuote
  include Interactor

  def call
    user = context.user
    recommend_strategy = if user.nil?
                           AnonymousRecommenderService.new(user)
                         else
                           case
                           when user.random?
                             RandomRecommenderService.new(user)
                           when user.strategy1?
                             AnonymousRecommenderService.new(user)
                           when user.strategy2?
                             AnonymousRecommenderService.new(user)
                           end
                         end

    context.result = recommend_strategy.show_next
  end
end
