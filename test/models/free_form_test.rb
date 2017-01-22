require 'test_helper'

class FreeFormTest < ActiveSupport::TestCase
  include CommonCardTest

  def setup
    @user = users(:michael)
    @card = @user.cards.build(type: 'FreeForm',
                              name: 'Frenzy',
                              source: sources(:dnd),
                              card_size: '25x35',
                              icon: 'white-book',
                              color: 'indigo',
                              contents: 'subtitle|Rogue feature')
  end

  test 'icon should be present' do
    @card.icon = '     '
    assert_not @card.valid?
  end

  test 'color should be present' do
    @card.color = '     '
    assert_not @card.valid?
  end

  test 'should generate card data' do
    card_data = @card.card_data

    assert_equal 'Frenzy', card_data.name
    assert_equal '25x35', card_data.card_size

    assert_equal 'white-book', card_data.icon
    assert_equal 'indigo', card_data.color

    card_content = card_data.contents
    assert_equal 1, card_content.size

    first = card_content.first
    assert first.subtitle?
    assert_equal 'Rogue feature', first.args.first
  end

  test 'should generate card data with special card size' do
    @card.card_size = '35x50'
    card_data = @card.card_data

    assert_equal '35x50', card_data.card_size
  end
end
