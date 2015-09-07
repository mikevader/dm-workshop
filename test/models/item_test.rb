require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @item = @user.items.build(name: "Wand of Nerdom", category_id: categories(:wand).id, rarity_id: rarities(:rare).id, attunement: true, description: 'Turn geek')
  end

  test "should be valid" do
    assert @item.valid?
  end

  test "user id should be present" do
    @item.user_id = nil
    assert_not @item.valid?
  end

  test "name should be present" do
    @item.name = "      "
    assert_not @item.valid?
  end

  test "name should be no longer than 50 characters" do
    @item.name = 'q' * 51
    assert_not @item.valid?
  end
  
  test "category id should be present" do
    @item.category_id = nil
    assert_not @item.valid?
  end
  
  test "rarity id should be present" do
    @item.rarity_id = nil
    assert_not @item.valid?
  end

  test "names should be unique" do
    duplicate_item = @item.dup
    duplicate_item.name = @item.name.upcase
    @item.save
    assert_not duplicate_item.valid?
  end

end
