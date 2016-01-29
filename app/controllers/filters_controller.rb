require 'search_engine'

class FiltersController < ApplicationController
  #layout :choose_layout
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]

  before_action :init_search_engine, only: [:show, :index]

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
    @results = search(params[:search])
  end

  def show
    @filter = Filter.find(params[:id])
    @filters = Filter.all

    @results = search(@filter.query)

    render :index
  end

  def new
  end

  def create
    @filter = current_user.filters.build(filter_params)
    if @filter.save
      flash[:success] = 'Card created!'
      redirect_to filter_path(@filter)
    else
      redirect_to filters_url
    end
  end

  def edit
  end

  def update
  end

  def destroy
    Filter.find(params[:id]).destroy
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

    @search_engines.each do |type, engine|
      result, error = engine.search(query, false)

      unless error
        results += result
      end
      #@error ||= error
    end

    results
  end
end
