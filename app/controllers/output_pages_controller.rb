require 'search_engine'

class OutputPagesController < ApplicationController
  layout 'print'
  before_action :logged_in_user, only: [:all, :free_forms, :spells, :monsters, :items]

  before_action :init_search_engine

  def all
    result, _normalized, _error = @search_engine.search(params[:search], false)

    @cards = result
  end

  def free_forms
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('freeform', params[:search]))

    @cards = result
  end

  def spells
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('spell', params[:search]))

    @cards = result
  end
  
  def items
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('item', params[:search]))

    @cards = result
  end

  def monsters
    result, _normalized, _error = @search_engine.search(combineTypeAndSearchExpression('monster', params[:search]))

    @cards = result
  end

  private
  def init_search_engine
    @search_engine =  SearchEngine2.new(policy_scope(Card))
  end

  def combineTypeAndSearchExpression(type, search)
    return "type = #{type}" if search.blank?

    return "type = #{type} AND #{search}"
  end
end
