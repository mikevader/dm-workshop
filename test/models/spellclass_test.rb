require 'test_helper'

class SpellclassTest < ActiveSupport::TestCase
  
  def setup
    @spellclass = Spellclass.new(spell_id: 1, hero_class_id: 1)
  end
  
  test "should be valid" do
    assert @spellclass.valid?
  end
  
  test "should require a spell_id" do
    @spellclass.spell_id = nil
    assert_not @spellclass.valid?
  end

  test "should require a followed_id" do
    @spellclass.hero_class_id = nil
    assert_not @spellclass.valid?
  end
end
