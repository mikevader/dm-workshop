require 'test_helper'

class CardTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @card = @user.cards.build(name: 'Frenzy', icon: 'white-book', color: 'indigo', contents: 'subtitle|Rogue feature')
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
end
