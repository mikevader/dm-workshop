class MonstersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @monsters = Monster.all.paginate(page: params[:page]).order(:name)
  end

  def show
    @monster = Monster.find(params[:id])
  end

  def new
    @monster = current_user.monsters.build
  end
  
  def create
    @monster = curent_user.monsters.build(monster_params)
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
    redirect_to monsters_path
  end

  private
  def monster_params
    params.require(:spell).permit(:name, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed,  :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :saving_throws, :skills, :damage_vulnerabilities, :damage_resistences, :damage_immunities, :condition_immunities, :senses, :languages, :challenge, :description)
  end
  
  def correct_user
    @spell = Spell.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@spell.user) || admin_user?
  end
  
  def admin_user
    redirect_to root_url unless admin_user?
  end
end
