class RatingsController < ApplicationController
  def update
    unless current_user
      redirect_to root_path
      return
    end

    @quote = Quote.find(params[:id])
    @rating = Rating.find_or_create_by!(quote_id: @quote.id, user_id: current_user.id)

    respond_to do |format|
      if @rating.update(user_rating: params[:user_rating])
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
