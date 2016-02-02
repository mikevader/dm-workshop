require 'test_helper'

class FilterTest < ActiveSupport::TestCase
  setup do
    @user = users(:michael)
    @filter = @user.filters.build(name: 'JahrDesGreifen')
  end

  test 'should be valid' do
    assert @filter.valid?
  end

  test 'user_id should be present' do
    @filter.user_id = nil
    assert_not @filter.valid?, 'Filter must belong to a user.'
  end

  test 'name should be present' do
    @filter.name = '     '
    assert_not @filter.valid?
  end
end
