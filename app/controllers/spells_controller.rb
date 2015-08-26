class SpellsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :correct_user, only: :destroy
  
  def index
    @spell = current_user.spells.build
    @spells = Spell.paginate(page: params[:page])
  end

  def new
  end
  
  def create
    @spell = current_user.spells.build(spell_params)
    if @spell.save
      flash[:success] = "Spell created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
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
    @spell.destroy
    flash[:success] = "Spell deleted"
    redirect_to request.referrer || root_url
  end
  
  private
  def spell_params
    params.require(:spell).permit(:name, :level, :school, :classes, :casting_time, :range, :components, :duration,  :short_description, :description, :picture)
  end
  
  def correct_user
    @spell = current_user.spells.find_by(id: params[:id])
    redirect_to root_url if @spell.nil?
  end
end
