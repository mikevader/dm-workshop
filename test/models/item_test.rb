require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @item = @user.cards.build(type: 'Item',
                              name: 'Wand of Nerdom',
                              card_size: '25x35',
                              category_id: categories(:wand).id,
                              rarity_id: rarities(:rare).id,
                              attunement: true,
                              description: 'Turn geek')
  end

  test 'should be valid' do
    assert @item.is_a? Item
    assert @item.valid?, @item.errors.messages
  end

  test 'user id should be present' do
    @item.user_id = nil
    assert_not @item.valid?
  end

  test 'name should be present' do
    @item.name = '      '
    assert_not @item.valid?
  end

  test 'name should be no longer than 50 characters' do
    @item.name = 'q' * 51
    assert_not @item.valid?
  end

  test 'category id should be present' do
    @item.category_id = nil
    assert_not @item.valid?
  end

  test 'rarity id should be present' do
    @item.rarity_id = nil
    assert_not @item.valid?
  end

  test 'names should be unique' do
    duplicate_item = @item.dup
    duplicate_item.name = @item.name.upcase
    @item.save
    assert_not duplicate_item.valid?
  end

  test 'replicate should duplicate all item attributes' do
    @item.properties << Property.new(name: 'Test', value: 'Test Value')
    @item.save
    @item.reload
    replicate = @item.replicate

    assert_equal @item.name, replicate.name
    assert_equal @item.category, replicate.category
    assert_equal @item.rarity, replicate.rarity
    assert_equal @item.attunement, replicate.attunement
    assert_equal @item.description, replicate.description
    assert_equal @item.properties.size, replicate.properties.size
    assert_equal 1, replicate.properties.size
    assert_equal 'Test', replicate.properties.first.name
    assert_equal 'Test Value', replicate.properties.first.value
  end

  test 'replicate should work with tags as well' do
    @item.tag_list.add('dsa')
    @item.save
    @item.reload

    replicate = @item.replicate
    assert_includes replicate.tag_list, 'dsa'
  end
end
