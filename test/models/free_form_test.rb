require 'test_helper'

class FreeFormTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @card = @user.cards.build(type: 'FreeForm', name: 'Frenzy', icon: 'white-book', color: 'indigo', contents: 'subtitle|Rogue feature')
  end

  test 'should be valid' do
    assert @card.valid?
  end

  test 'user_id should be present' do
    @card.user_id = nil
    assert_not @card.valid?, 'Card must belong to a user.'
  end

  test 'name should be present' do
    @card.name = '     '
    assert_not @card.valid?
  end

  test 'icon should be present' do
    @card.icon = '     '
    assert_not @card.valid?
  end

  test 'color should be present' do
    @card.color = '     '
    assert_not @card.valid?
  end

  test 'replicate should work with tags as well' do
    @card.tag_list.add('dsa')
    @card.save
    @card.reload

    replicate = @card.replicate
    assert_includes replicate.tag_list, 'dsa'
  end

  test 'should generate card data' do
    card_data = @card.card_data

    assert_equal 'Frenzy', card_data.name
    assert_equal 'white-book', card_data.icon
    assert_equal 'indigo', card_data.color

    card_content = card_data.contents
    assert_equal 1, card_content.size

    first = card_content.first
    assert first.subtitle?
    assert_equal 'Rogue feature', first.args.first
  end

end
