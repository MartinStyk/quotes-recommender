class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :show_alert

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_path
  end

  private

  def show_alert
    flash[:danger] = 'The object you tried to access does not exist'
    redirect_to action: :index
  end
end
