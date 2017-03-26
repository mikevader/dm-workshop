require 'test_helper'

class SpellsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @source = sources(:dnd)
  end


  test '' do
    log_in_as(@user)

    # create your spellbook
    get spellbooks_path



    get spells_path


  end
end
