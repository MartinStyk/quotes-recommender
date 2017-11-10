# app/interactors/recommend_quote.rb
class RecommendQuote
  include Interactor

  def call
    user = context.user
    show_different = context.show_different

    recommend_strategy = if user.nil?
                           AnonymousRecommenderService.new(user)
                         else
                           case
                             when user.random?
                               RandomRecommenderService.new(user)
                             when user.content_based_binary?
                               ContentBasedBinaryRecommenderService.new(user, show_different)
                             when user.global_popularity?
                               GlobalPopularityRecommenderService.new(user, show_different)
                             when user.content_based_quote_analysis?
                               ContentBasedQuoteAnalysisRecommenderService.new(user, show_different)
                             when user.content_based_mixed?
                               ContentBasedMixedRecommenderService.new(user, show_different)
                             else
                               AnonymousRecommenderService.new(user)
                           end
                         end

    context.result = recommend_strategy.show_next
  end
end
