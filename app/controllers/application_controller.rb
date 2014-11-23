class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception

  def authenticate_customer!
    if current_customer.present?
      @current_customer = current_customer
    else
      flash[:error] = 'You must be logged in!'
      redirect_to '/'
    end
  end
end
