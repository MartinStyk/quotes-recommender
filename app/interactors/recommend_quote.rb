class RecommendQuote
  include Interactor

  def call
    user = context.user
    recommend_strategy = if user.nil?
                           AnonymousRecommenderService.new(user)
                         else
                           case user.strategy
                           when 'random'
                             RandomRecommenderService.new(user)
                           when 'strategy1'
                             AnonymousRecommenderService.new(user)
                           when 'strategy2'
                             AnonymousRecommenderService.new(user)
                           end
                         end

    context.result = recommend_strategy.show_next
  end
end
