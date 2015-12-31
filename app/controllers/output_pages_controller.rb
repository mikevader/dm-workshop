require 'search_engine'

class OutputPagesController < ApplicationController
  layout 'print'

  before_action :init_search_engine_cards, only: [:cards]
  before_action :init_search_engine_spells, only: [:spells]
  before_action :init_search_engine_items, only: [:items]
  before_action :init_search_engine_monsters, only: [:monsters]

  def init_search_engine_cards
    @search_engine = SearchEngine2.new(Card)
  end

  def init_search_engine_spells
    @search_engine = SearchEngine2.new(Spell)
  end
  
  def init_search_engine_items
    @search_engine = SearchEngine2.new(Item)
  end
  
  def init_search_engine_monsters
    @search_engine = SearchEngine2.new(Monster)
  end

  def cards
    result, error = @search_engine.search(params[:search])

    @cards = result
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
