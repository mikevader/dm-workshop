class FreeFormsController < CardsController

  private
  def search_path
    free_forms_path
  end

  def print_path(*search_args, &blk)
    print_free_forms_path(*search_args, &blk)
  end
end
