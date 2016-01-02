require 'search_engine'

class ItemsController < ApplicationController
  layout 'card_index', only: [:index]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  before_action :init_search_engine, only: [:index]
  
  def init_search_engine
    @search_engine = SearchEngine2.new(Item)
  end
  
  def index
    result, error = @search_engine.search(params[:search])
    
    @items = result.paginate(page: params[:page])
    @error = error
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end
  
  def create
    @item = current_user.items.build(item_params)
    if @item.save
      flash[:success] = "Item crafted!"
      redirect_to items_url
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      flash[:success] = "Item udpated"
      redirect_to items_url
    else
      render 'edit'
    end
  end
  
  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = "Item deleted"
    redirect_to items_url
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      item = Item.find(params[:id])
      item.assign_attributes(item_params)
      card_data = item.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data}
  end

  private
  def item_params
    params.require(:item).permit(:name, :cssclass, :category_id, :rarity_id, :attunement, :description, properties_attributes: [:id, :name, :value, :_destroy])
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless admin_user?
  end
end
