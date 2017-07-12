class MonstersController < CardsController

  private
  def search_path
    monsters_path
  end

  def print_path(*search_args, &blk)
    print_monsters_path(*search_args, &blk)
  end
end
