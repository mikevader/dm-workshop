require 'search_engine'

class OutputPagesController < ApplicationController
  layout 'print'

  before_action :init_search_engine_spells, only: [:spells]
  before_action :init_search_engine_items, only: [:items]
  before_action :init_search_engine_monsters, only: [:monsters]
  
  def init_search_engine_spells
    @search_engine = SearchEngine2.new(Spell)
  end
  
  def init_search_engine_items
    @search_engine = SearchEngine2.new(Item)
  end
  
  def init_search_engine_monsters
    @search_engine = SearchEngine2.new(Monster)
  end
  
  def spells
    result, error = @search_engine.search(params[:search])
    
    @spells = result
  end
  
  def items
    result, error = @search_engine.search(params[:search])
    
    @items = result
  end

  def monsters
    result, error = @search_engine.search(params[:search])
    
    @monsters = result
  end
end
