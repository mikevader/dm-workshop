require 'test_helper'

class HeroClassesInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "hero classes interface" do
    log_in_as(@user)
    get hero_classes_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'HeroClass.count' do
      post hero_classes_path, hero_class: { name: "", cssclass: ""}
    end
    assert_select 'div#error_explanation'
    # Valid submission
    name = "Vagabund"
    cssclass = "vagabund-icon"
    assert_difference 'HeroClass.count', 1 do
      post hero_classes_path, hero_class: { name: name, cssclass: cssclass }
    end
    assert_redirected_to hero_classes_url
    follow_redirect!
    assert_match name, response.body
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_hero_class = HeroClass.paginate(page: 1).first
    assert_difference 'HeroClass.count', -1 do
      delete hero_class_path(first_hero_class)
    end
  end
end
