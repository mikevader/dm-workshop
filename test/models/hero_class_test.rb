require 'test_helper'

class HeroClassTest < ActiveSupport::TestCase

  setup do
    @hero_class = HeroClass.new(name: 'Gronk', cssclass: 'icon-gronk')
  end

  test 'should be valid' do
    assert @hero_class.valid?
  end

  test 'name should be present' do
    @hero_class.name = nil
    assert_not @hero_class.valid?
  end

  test 'name should not be too long' do
    @hero_class.name = 'a' * 51
    assert_not @hero_class.valid?
  end

  test 'name should be unique' do
    @hero_class.save
    other_class = HeroClass.new(name: 'Gronk', cssclass: 'icon-gronk')
    assert_not other_class.valid?
  end

  test 'cssclass should be present' do
    @hero_class.cssclass = nil
    assert_not @hero_class.valid?
  end

  test 'cssclass should not be too long' do
    @hero_class.cssclass = 'b' * 51
    assert_not @hero_class.valid?
  end

end
