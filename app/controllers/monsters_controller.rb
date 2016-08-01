class MonstersController < CardsController

  private
  def search_path
    monsters_path
  end

  def print_path(search_args)
    print_monsters_path(search_args)
  end
end
