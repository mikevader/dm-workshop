class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :edit_path, :duplicate_path
  include SessionsHelper
  include Pagy::Backend
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  def admin_user
    redirect_to root_url unless admin_user?
  end
  def user_not_authorized(exception)
    if logged_in?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    else
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def new_path
    name = card_model.name.underscore
    send("new_#{name}_path")
  end

  def edit_path card
    name = card.class.name.underscore
    send("edit_#{name}_path", card)
  end

  def duplicate_path card
    name = card.class.name.underscore
    send("duplicate_#{name}_path", card)
  end
end
