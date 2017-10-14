class ApplicationController < ActionController::Base
  # `prepend: true` because of 'Can't verify CSRF token authenticity.'??
  protect_from_forgery prepend: true, with: :exception
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
