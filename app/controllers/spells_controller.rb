class SpellsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @spells = Spell.paginate(page: params[:page])
  end

  def new
    @spell = current_user.spells.build
  end
  
  def create
    @spell = current_user.spells.build(spell_params)
    if @spell.save
      flash[:success] = "Spell created!"
      redirect_to spells_path
    else
      render 'new'
    end
  end
    
  def edit
    @spell = Spell.find(params[:id])
  end
  
  def update
    @spell = Spell.find(params[:id])
    if @spell.update_attributes(spell_params)
      flash[:success] = "Spell updated"
      redirect_to spells_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Spell.find(params[:id]).destroy
    flash[:success] = "Spell deleted"
    redirect_to spells_url
  end
  
  private
  def spell_params
    params.require(:spell).permit(:name, :level, :school, :classes, :casting_time, :range, :components, :duration,  :short_description, :description, :picture)
  end
  
  def correct_user
    @spell = Spell.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@spell.user) || admin_user?
  end
  
  def admin_user
    redirect_to root_url unless admin_user?
  end
end

