require 'search_engine'

class GenericCardController < ApplicationController
  include ColumnsHelper

  layout :choose_layout
  helper_method :card_model, :new_path, :edit_path, :destroy_path, :duplicate_path
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy]
  #before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :init_search_engine, only: [:index]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def init_search_engine
    @search_engine = SearchEngine2.new(policy_scope(card_model))
  end


  # Create actions
  def new
    authorize card_model
    @card = user_collection.build
  end


  # Read actions
  def index
    authorize card_model
    result, error = search_engine.search(params[:search])

    @cards = result
    @error = error
    @cards.each {|card| authorize card}
  end

  def show
    authorize card_model
    @card = card_model.find(params[:id])
    authorize @card
  end


  # Update actions
  def edit
    @card = card_model.find(params[:id])
    authorize @card
  end


  private
  def new_path
  end

  def edit_path card
    name = card.class.name.downcase
    send("edit_#{name}_path", card)
  end

  def destroy_path card
  end

  def duplicate_path card
    name = card.class.name.downcase
    send("duplicate_#{name}_path", card)
  end

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