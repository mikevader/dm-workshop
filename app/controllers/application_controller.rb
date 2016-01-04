class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Select the layout depending on the CRUD mode
  def choose_layout
    case action_name
      when 'index'
        return 'card_index'
      when 'edit'
        return 'card_edit'
      when 'new'
        return 'card_new'
      else
        return nil
    end
  end
end
