class OutputPagesController < ApplicationController
  layout 'print'
  def spells
    @spells = Spell.includes(:hero_classes).all
  end
end
