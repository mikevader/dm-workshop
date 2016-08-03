require 'search_engine'

class FiltersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :init_search_engine, only: [:show, :index]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def init_search_engine
    @search_engine = SearchEngine2.new(policy_scope(Card))
  end

  def index
    @filters = policy_scope(Filter).all
    @cards, normalized, @error = @search_engine.search(params[:search], false)
    params[:search] = normalized
    @filters.each {|filter| authorize filter}
    @cards.each {|card| authorize card}
    @filter = current_user.filters.build(query: params[:search])
  end

  def show
    @filter = Filter.find(params[:id])
    @filters = policy_scope(Filter).all
    authorize @filter
    @filters.each {|filter| authorize filter}

    @cards, normalize, @error = @search_engine.search(@filter.query, false)
    params[:search] = normalize
    @cards.each {|card| authorize card}

    render :index
  end

  def new
    authorize Filter
  end

  def create
    @filter = current_user.filters.build(filter_params)
    authorize @filter
    if @filter.save
      flash[:success] = 'Filter created!'
      redirect_to filter_path(@filter)
    else
      render :index
    end
  end

  def edit
    authorize Filter
  end

  def update
    @filter = Filter.find(params[:id])
    authorize @filter
    if @filter.update_attributes(filter_params)
      flash[:success] = 'Filter updated!'
      redirect_to filter_path(@filter)
    else
      render :index
    end
  end

  def destroy
    card = Filter.find(params[:id])
    authorize card
    card.destroy
    flash[:success] = 'Filter removed!'
    redirect_to filters_url
  end

  private
  def filter_params
    params.require(:filter).permit(:name, :query, :shared)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
