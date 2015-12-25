require 'test_helper'

class HeroClassesControllerTest < ActionController::TestCase
  
  def setup
    @hero_class = hero_classes(:gunslinger)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    post :edit, id: @hero_class
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @hero_class, name: { name: 'gunser', cssclass: 'foo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'HeroClass.count' do
      delete :destroy, id: @hero_class
    end
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show, id: @hero_class
    assert_response :success
  end
  
  test "delete should remove hero class" do
    log_in_as(users(:michael))
    hero = hero_classes(:goliath)
    assert_difference 'HeroClass.count', -1 do
      delete :destroy, id: hero
    end
    assert_redirected_to hero_classes_url
  end

  test "create should add new hero class" do
    log_in_as(users(:michael))
    assert_difference 'HeroClass.count', +1 do
      post :create, hero_class: { name: 'Nerd', cssclass: 'nerd-icons' }
    end
    assert_redirected_to hero_classes_url
  end
  
  test "update should change existing hero class" do
    log_in_as(users(:michael))
    hero = hero_classes(:goliath)
    hero.name = 'qua?'
  
    assert_no_difference 'HeroClass.count' do
      patch :update, id: hero, hero_class: { name: 'Qua?' }
    end
    assert_redirected_to hero_classes_url
  end

end
