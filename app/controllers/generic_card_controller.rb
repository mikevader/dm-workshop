require 'search_engine'

class GenericCardController < ApplicationController
  include ColumnsHelper

  layout :choose_layout
  helper_method :card_model
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy]
  #before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :init_search_engine, only: [:index]
  after_action :verify_authorized

  def init_search_engine
    @search_engine = SearchEngine2.new(card_model)
  end


  # Create actions
  def new
    @card = user_collection.build
    authorize @card
  end


  # Read actions
  def index
    result, error = search_engine.search(params[:search])

    @cards = result
    @error = error
    authorize card_model
  end

  def show
    @card = card_model.find(params[:id])
    authorize @card
  end


  # Update actions
  def edit
    @card = card_model.find(params[:id])
    authorize @card
  end


  private

  def user_collection
    current_user.send(controller_name)
  end

  def card_model
    controller_name.classify.constantize
  end

  def search_engine
    @search_engine
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