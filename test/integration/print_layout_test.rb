require 'test_helper'

class PrintLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "spell interface" do
    log_in_as(@user)
    get print_spells_path
  end

  test "item interface" do
    log_in_as(@user)
    get print_items_path
  end

end
