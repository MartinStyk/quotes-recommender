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
                           when user.content_based_binary?
                             ContentBasedBinaryRecommenderService.new(user)
                           when user.global_popularity?
                             GlobalPopularityRecommenderService.new(user)
                           end
                         end

    context.result = recommend_strategy.show_next
  end
end
