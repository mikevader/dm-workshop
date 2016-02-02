require 'search_engine'

class CardsController < ApplicationController
  layout :choose_layout
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  before_action :init_search_engine, only: [:index]

  def init_search_engine
    @search_engine = SearchEngine2.new(Card)
  end

  def index
    result, error = @search_engine.search(params[:search])

    @cards = result
    @error = error
  end

  def show
    @card = Card.find(params[:id])
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      flash[:success] = 'Card created!'
      redirect_to cards_url
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Card.find(params[:id]).replicate
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Card duplicated!"
      redirect_to cards_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def edit
    @card = Card.find(params[:id])
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      flash[:success] = 'Card updated!'
      redirect_to cards_url
    else
      render 'edit', layout: 'card_edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    flash[:success] = 'Card removed!'
    redirect_to cards_url
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      card = nil
      if Card.exists?(params[:id])
        card = Card.find(params[:id])
      else
        card = current_user.cards.build
      end
      card.assign_attributes(card_params)
      card_data = card.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data}
  end

  def modal
    card = Card.find(params[:id])

    render partial: 'shared/modal_body', locals: { card: card, index: params[:index], modal_size: params[:modal_size], prev_index: params[:previd], next_index: params[:nextid] }
  end

  private
  def card_params
    params.require(:card).permit(:name, :tag_list, :icon, :color, :contents)
  end

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
end
