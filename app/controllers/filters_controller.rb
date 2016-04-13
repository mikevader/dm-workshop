require 'search_engine'

class FiltersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :init_search_engine, only: [:show, :index]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def init_search_engine
    @search_engines = {
        free_form: SearchEngine2.new(policy_scope(FreeForm)),
        item: SearchEngine2.new(policy_scope(Item)),
        spell: SearchEngine2.new(policy_scope(Spell)),
        monster: SearchEngine2.new(policy_scope(Monster))
    }
  end

  def index
    @filters = policy_scope(Filter).all
    @cards, @error = search(params[:search])
    @filters.each {|filter| authorize filter}
    @cards.each {|card| authorize card}
    @filter = current_user.filters.build(query: params[:search])
  end

  def show
    @filter = Filter.find(params[:id])
    @filters = policy_scope(Filter).all
    authorize @filter
    @filters.each {|filter| authorize filter}

    @cards, @error = search(@filter.query)
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

  def search(query)
    results = []
    errors = ''

    @search_engines.each do |type, engine|
      result, error = engine.search(query, false)

      unless error
        results += result
      end
      errors << error unless error.nil?
    end

    errors = nil if errors.blank?

    return results, errors
  end
end
