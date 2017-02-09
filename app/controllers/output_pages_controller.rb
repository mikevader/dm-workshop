class OutputPagesController < ApplicationController
  layout 'print'
  before_action :logged_in_user, only: [:all, :free_forms, :monsters, :items]

  def all
    search_engine = Search::SearchEngine.new(policy_scope(Card))
    result, _normalized, _error = search_engine.search(params[:search], false)

    @pages = Guillotine.insert(result)
  end

  def free_forms
    search_engine =  Search::SearchEngine.new(policy_scope(FreeForm))
    result, _normalized, _error = search_engine.search(combineTypeAndSearchExpression('freeform', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  def spells
    search_engine =  Search::SearchEngine.new(policy_scope(Spell))
    result, _normalized, _error = search_engine.search(combineTypeAndSearchExpression('spell', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end
  
  def items
    search_engine =  Search::SearchEngine.new(policy_scope(Item))
    result, _normalized, _error = search_engine.search(combineTypeAndSearchExpression('item', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  def monsters
    search_engine =  Search::SearchEngine.new(policy_scope(Monster))
    result, _normalized, _error = search_engine.search(combineTypeAndSearchExpression('monster', params[:search]))

    @pages = Guillotine.insert(result)
    render :all
  end

  private
  def combineTypeAndSearchExpression(type, search)
    return "type = #{type}" if search.blank?

    return "type = #{type} AND #{search}"
  end
end
