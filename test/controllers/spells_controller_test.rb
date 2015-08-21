require 'test_helper'

class SpellsControllerTest < ActionController::TestCase

  def setup
    @spell = spells(:bane)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Spell.count' do
      post :create, spell: { description: "Woopsie" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Spell.count' do
      post :destroy, id: @spell
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    spell = spells(:fireball)
    assert_no_difference 'Spell.count' do
      delete :destroy, id: spell
    end
    assert_redirected_to root_url
  end
end
