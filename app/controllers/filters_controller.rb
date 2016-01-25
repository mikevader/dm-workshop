class FiltersController < ApplicationController
  #layout :choose_layout
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]

  def index
    @filters = Filter.all
  end

  def show
  end

  def new
  end

  def create
    @filter = current_user.filters.build(filter_params)
    if @filter.save
      flash[:success] = 'Card created!'
      redirect_to filters_url
    else
      redirect_to filters_url
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def filter_params
    params.require(:filter).permit(:name, :query)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
