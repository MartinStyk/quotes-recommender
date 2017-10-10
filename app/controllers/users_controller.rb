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
end
