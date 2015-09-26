require 'search_engine'

class MonstersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  before_action :init_search_engine, only: [:index]
  
  def init_search_engine
    @search_engine = SearchEngine2.new(Monster)
  end
  
  def index
    result, error = @search_engine.search(params[:search])
    
    @monsters = result.paginate(page: params[:page])
    @error = error
  end

  def show
    @monster = Monster.find(params[:id])
  end

  def new
    @monster = current_user.monsters.build
  end
  
  def create
    @monster = current_user.monsters.build(monster_params)
    if @monster.save
      flash[:success] = "Monster bread!"
      redirect_to monsters_path
    else
      render 'new'
    end
  end

  def edit
    @monster = Monster.find(params[:id])
  end
  
  def update
    @monster = Monster.find(params[:id])
    if @monster.update_attributes(monster_params)
      flash[:success] = "Monster evolved!"
      redirect_to monsters_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Monster.find(params[:id]).destroy
    flash[:success] = "Monster killed!"
    redirect_to monsters_url
  end

  private
  def monster_params
    params.require(:monster).permit(:name, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed,  :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :damage_vulnerabilities, :damage_resistences, :damage_immunities, :condition_immunities, :senses, :languages, :challenge, :description, :bonus, :monsters_skills, :skills, :saving_throws => [], :monsters_skills_ids => [], :skill_ids => [])
  end
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @monster = Monster.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@monster.user) || admin_user?
  end
  
  def admin_user
    redirect_to root_url unless admin_user?
  end
end
