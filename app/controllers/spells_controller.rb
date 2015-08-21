class SpellsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
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
