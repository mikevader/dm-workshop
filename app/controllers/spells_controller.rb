class SpellsController < CardsController

  private
  def search_path
    spells_path
  end

  def print_path(*search_args, &blk)
    print_spells_path(*search_args, &blk)
  end
end

