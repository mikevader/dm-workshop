require 'search_engine'

class SpellsController < CardsController
  private
  def search_path
    spells_path
  end

  def print_path(search_args)
    print_spells_path(search_args)
  end
end

