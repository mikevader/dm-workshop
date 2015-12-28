require 'search_engine'

class CardsController < ApplicationController
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
      render 'new'
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
      render 'edit'
    end
  end

  def destroy
    Card.find(params[:id]).destroy
    flash[:success] = 'Card removed!'
    redirect_to cards_url
  end

  def change_card
    card = Card.find(params[:id])
    card.assign_attributes(card_params)
    render partial: 'shared/card_card', locals: { card: card.card_data }
  end

  private
  def card_params
    params.require(:card).permit(:name, :icon, :color, :contents)
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
