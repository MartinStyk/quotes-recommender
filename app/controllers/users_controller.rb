class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index]

  def index
    @users = User.all.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_back(fallback_location: root_path)
      flash[:warning] = 'Access denied.'
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:strategy)
  end
end
