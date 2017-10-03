class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :show_alert

  private

  def show_alert
    flash[:danger] = 'The object you tried to access does not exist'
    redirect_to action: :index
  end
end
