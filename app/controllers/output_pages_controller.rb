class OutputPagesController < ApplicationController
  layout 'print'
  before_action :logged_in_user, only: [:all, :free_forms, :spells, :monsters, :items]

  before_action :init_search_engine

  def all
    result, _normalized, _error = @search_engine.search(params[:search], false)

    @pages = Guillotine.insert(result)
  end

  def free_forms
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('freeform', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  def spells
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('spell', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end
  
  def items
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('item', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  def monsters
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('monster', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  private
  def init_search_engine
    @search_engine =  Search::SearchEngine.new(policy_scope(Card))
  end

  def combineTypeAndSearchExpression(type, search)
    return "type = #{type}" if search.blank?

    return "type = #{type} AND #{search}"
  end
end
