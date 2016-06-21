require 'search_engine'

class OutputPagesController < ApplicationController
  layout 'print'
  before_action :logged_in_user, only: [:all, :free_forms, :spells, :monsters, :items]

  before_action :init_search_engine_all, only: [:all]
  before_action :init_search_engine_free_forms, only: [:free_forms]
  before_action :init_search_engine_spells, only: [:spells]
  before_action :init_search_engine_items, only: [:items]
  before_action :init_search_engine_monsters, only: [:monsters]

  def init_search_engine_free_forms
    @search_engine = SearchEngine2.new(policy_scope(FreeForm))
  end

  def init_search_engine_spells
    @search_engine = SearchEngine2.new(policy_scope(Spell))
  end
  
  def init_search_engine_items
    @search_engine = SearchEngine2.new(policy_scope(Item))
  end
  
  def init_search_engine_monsters
    @search_engine = SearchEngine2.new(policy_scope(Monster))
  end

  def init_search_engine_all
    @search_engines = {
        cards: SearchEngine2.new(policy_scope(Card))
    }
  end

  def all
    results = []
    @search_engines.each do |_type, engine|
      result, error = engine.search(params[:search], false)

      unless error
        results += result
      end
    end

    @cards = results
  end

  def free_forms
    result, _error = @search_engine.search(params[:search])

    @cards = result
  end

  def spells
    result, _error = @search_engine.search(params[:search])

    @cards = result
  end
  
  def items
    result, _error = @search_engine.search(params[:search])

    @cards = result
  end

  def monsters
    result, _error = @search_engine.search(params[:search])

    @cards = result
  end
end
