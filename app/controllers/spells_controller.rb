require 'search_engine'

class SpellsController < ApplicationController
  layout :choose_layout
  before_action :logged_in_user, only: [:index, :edit, :update, :create, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  before_action :init_search_engine, only: [:index]
  
  def init_search_engine
    @search_engine = SearchEngine2.new(Spell)
  end
  
  def index
    result, error = @search_engine.search(params[:search])
    
    @cards = result
    @error = error
  end

  def new
    @card = current_user.spells.build
  end
  
  def create
    @card = current_user.spells.create(spell_params)
    if @card.save
      flash[:success] = 'Spell inscribed!'
      redirect_to spells_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Spell.find(params[:id]).replicate
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Spell copied!"
      redirect_to spells_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def edit
    @card = Spell.find(params[:id])
  end
  
  def update
    @card = Spell.find(params[:id])
    if @card.update_attributes(spell_params)
      flash[:success] = 'Spell updated'
      redirect_to spells_path
    else
      render 'edit', layout: 'card_edit'
    end
  end
  
  def destroy
    Spell.find(params[:id]).destroy
    flash[:success] = 'Spell deleted'
    redirect_to spells_url
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      if Spell.exists?(params[:id])
        spell = Spell.find(params[:id])
      else
        spell = current_user.spells.build
      end
      spell.assign_attributes(spell_params)
      card_data = spell.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data }
  end

  private
  def spell_params
    params.require(:spell).permit(:name, :tag_list, :cite, :ritual, :level, :school, :casting_time, :range, :components, :duration, :short_description, :athigherlevel, :description, :picture, :concentration, :hero_classes, :hero_class_ids => [])
  end
  
  def correct_user
    @card = Spell.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@card.user) || admin_user?
  end
  
  def admin_user
    redirect_to root_url unless admin_user?
  end
end

