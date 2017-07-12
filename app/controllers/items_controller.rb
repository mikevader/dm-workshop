class ItemsController < CardsController

  private
  def search_path
    items_path
  end

  def print_path(*search_args, &blk)
    print_items_path(*search_args, &blk)
  end
end
