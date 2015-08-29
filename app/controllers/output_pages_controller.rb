class OutputPagesController < ApplicationController
  layout 'print'
  def spells
    @spells = Spell.all
  end
end
