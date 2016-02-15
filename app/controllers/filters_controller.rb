require 'search_engine'

class FiltersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :init_search_engine, only: [:show, :index]
  after_action :verify_authorized

  def init_search_engine
    @search_engines = {
        cards: SearchEngine2.new(Card),
        items: SearchEngine2.new(Item),
        spells: SearchEngine2.new(Spell),
        monsters: SearchEngine2.new(Monster)
    }
  end

  def index
    @filters = Filter.all
    @cards, @error = search(params[:search])
    authorize @filters
  end

  def show
    @filter = Filter.find(params[:id])
    @filters = Filter.all

    @cards, @error = search(@filter.query)
    authorize @filters
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
    params.require(:filter).permit(:name, :query)
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
