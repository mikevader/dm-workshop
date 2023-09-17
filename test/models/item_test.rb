require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  include CommonCardTest

  setup do
    @user = users(:michael)
    @card = @item = @user.cards.build(
                              type: 'Item',
                              name: 'Wand of Nerdom',
                              source: sources(:dnd),
                              card_size: '25x35',
                              category_id: categories(:wand).id,
                              rarity_id: rarities(:rare).id,
                              attunement: true,
                              description: 'Turn geek')
  end

  test 'category id should be present' do
    @item.category_id = nil
    assert_not @item.valid?
  end

  test 'rarity id should be present' do
    @item.rarity_id = nil
    assert_not @item.valid?
  end

  test 'replicate should duplicate all item attributes' do
    skip("properties seem not to work properly")
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

end
