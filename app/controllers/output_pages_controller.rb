class OutputPagesController < ApplicationController
  layout 'print'
  def spells
    @spells = Spell.includes(:hero_classes).all
  end
  
  def items
    @items = Item.all
  end
end
