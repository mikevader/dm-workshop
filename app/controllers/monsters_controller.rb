require 'search_engine'

class MonstersController < ApplicationController
  layout :choose_layout
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  before_action :init_search_engine, only: [:index]
  
  def init_search_engine
    @search_engine = SearchEngine2.new(Monster)
  end
  
  def index
    result, error = @search_engine.search(params[:search])
    
    @cards = result
    @error = error
  end

  def show
    @card = Monster.find(params[:id])
  end

  def new
    @card = current_user.monsters.build
  end
  
  def create
    @card = current_user.monsters.create(monster_required_params)
    if @card.update_attributes(monster_params)
      flash[:success] = "Monster bread!"
      redirect_to monsters_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Monster.find(params[:id]).replicate
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Monster cloned!"
      redirect_to monsters_path
    else
      render 'new', layout: 'card_new'
    end
  end
  
  def update
    @card = Monster.find(params[:id])
    if @card.update_attributes(monster_params)
      flash[:success] = "Monster evolved!"
      redirect_to monsters_path
    else
      render 'edit', layout: 'card_edit'
    end
  end
  
  def destroy
    Monster.find(params[:id]).destroy
    flash[:success] = "Monster killed!"
    redirect_to monsters_url
  end

  def edit
    @card = Monster.find(params[:id])
  end


  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      if Monster.exists?(params[:id])
        monster = Monster.find(params[:id])
      else
        monster = current_user.monsters.build
      end
      monster.assign_attributes(monster_params)
      card_data = monster.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data}
  end

  private
  def monster_required_params
    params.require(:monster).permit(:name, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma)
  end
  def monster_params
    params.require(:monster).permit(:name, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :senses, :languages, :challenge, :description, :bonus, :monsters_skills, :skills, :saving_throws => [], :damage_vulnerabilities => [], :damage_resistances => [], :damage_immunities => [], :cond_immunities => [], :monsters_skills_ids => [], :skill_ids => [], actions_attributes: [:id, :title, :description, :_destroy], traits_attributes: [:id, :title, :description, :_destroy])
  end
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @card = Monster.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@card.user) || admin_user?
  end
  
  def admin_user
    redirect_to root_url unless admin_user?
  end
end
