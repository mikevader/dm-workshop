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

  test "should redirect to index after destory" do
    log_in_as(users(:michael))
    spell = spells(:fireball)
    assert_difference 'Spell.count', -1 do
      delete :destroy, id: spell
    end
    assert_redirected_to spells_url
  end

  test "should redirect destroy for wrong spell" do
    log_in_as(users(:archer))
    spell = spells(:bane)
    assert_no_difference 'Spell.count' do
      delete :destroy, id: spell
    end
    assert_redirected_to root_url
  end

  test "should get duplicate" do
    log_in_as(users(:michael))
    spell = spells(:fireball)
    assert_difference 'Spell.count', +1 do
      post :duplicate, id: spell.id
    end
    assert_redirected_to spells_url

    duplicate = Spell.find_by_name "#{spell.name} (copy)"
    assert duplicate
    assert_equal users(:michael), duplicate.user
    assert_equal users(:archer), spell.user
  end
end
