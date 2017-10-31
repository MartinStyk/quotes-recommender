class RatingsController < ApplicationController
  before_action :authenticate_user!

  def update
    @quote = Quote.find(params[:id])

    Rating.transaction do

      # in case we edit already existing rating, we need to adjust categories preferences for current user
      # we need to decrement it
      if Rating.exists?(quote_id: @quote.id, user_id: current_user.id)
        adjust_user_category_preference Rating.find_by(quote_id: @quote.id, user_id: current_user.id), true
      end

      @rating = Rating.find_or_create_by!(quote_id: @quote.id, user_id: current_user.id)

      respond_to do |format|
        if @rating.update(user_rating: params[:user_rating])
          adjust_user_category_preference
          format.html
          format.json {render :show, status: :ok, location: root_path}
          format.js
        else
          format.html {redirect_to root_path, notice: 'Rating was NOT successfully updated.'}
          format.json {render json: @rating.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  private

  def adjust_user_category_preference(rating = @rating, decrement = false)
    @quote.categories.each do |category|
      @user_category_preference = UserCategoryPreference.find_or_create_by!(category_id: category.id, user_id: current_user.id)

      adjustment_value = rating.user_rating / Math.sqrt(@quote.categories.size)

      if @user_category_preference.preference.present?
        preference_value = decrement ? @user_category_preference.preference - adjustment_value : @user_category_preference.preference + adjustment_value
      else
        preference_value = adjustment_value
      end

      @user_category_preference.update(preference: preference_value)
    end
  end

end
