require 'test_helper'

class HeroClassesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @hero_class = hero_classes(:gunslinger)
  end

  test "should redirect index when not logged in" do
    get hero_classes_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_hero_class_path(@hero_class)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch hero_class_path(@hero_class), params: { id: @hero_class, name: { name: 'gunser', cssclass: 'foo' } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'HeroClass.count' do
      delete hero_class_path(@hero_class)
    end
    assert_redirected_to login_url
  end

  test "should get new" do
    get new_hero_class_path
    assert_response :success
  end

  test "should get show" do
    get hero_class_path(@hero_class)
    assert_response :success
  end
  
  test "delete should remove hero class" do
    log_in_as(users(:michael))
    hero = hero_classes(:goliath)
    assert_difference 'HeroClass.count', -1 do
      delete hero_class_path(hero), params: { id: hero }
    end
    assert_redirected_to hero_classes_url
  end

  test "create should add new hero class" do
    log_in_as(users(:michael))
    assert_difference 'HeroClass.count', +1 do
      post hero_classes_path, params: { hero_class: { name: 'Nerd', cssclass: 'nerd-icons' } }
    end
    assert_redirected_to hero_classes_url
  end
  
  test "update should change existing hero class" do
    log_in_as(users(:michael))
    hero = hero_classes(:goliath)
    hero.name = 'qua?'
  
    assert_no_difference 'HeroClass.count' do
      patch hero_class_path(hero), params: { id: hero, hero_class: { name: 'Qua?' } }
    end
    assert_redirected_to hero_classes_url
  end

end
