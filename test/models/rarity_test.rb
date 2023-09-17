require 'test_helper'

class RarityTest < ActiveSupport::TestCase

  setup do
    @rarity = Rarity.create(name: 'Legendary')
  end

  test 'should be valid' do
    assert @rarity.valid?
  end

  test 'name should be present' do
    @rarity.name = '    '
    assert_not @rarity.valid?
  end

  test 'name should not be longer than 50 characters' do
    @rarity.name = 'a' * 51
    assert_not @rarity.valid?
  end

  test 'names should be unique' do
    duplicate_rarity = @rarity.dup
    duplicate_rarity.name = @rarity.name.upcase
    @rarity.save
    assert_not duplicate_rarity.valid?
  end

end
