class RatingsController < ApplicationController
  before_action :set_rating, only: :update

  # def create
  #   @quote = Quote.find(params[:id])
  #   puts quote
  #   puts current_user.id
  #   @rating = Rating.create(quote_id: @quote.id, user_id: current_user.id, user_rating: params[:user_rating])
  # end

  # Like a scaffold for ratings update method
  # PATCH/PUT
  def update
    # @rating = Rating.new(rating_params)

    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to root_path, notice: 'Rating was successfully updated.' }
        format.json { render :show, status: :ok, location: root_path }
        format.js
      else
        format.html { redirect_to root_path, notice: 'Rating was NOT successfully updated.' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:quote_id, :user_id, :user_rating)
  end
end
