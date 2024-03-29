require 'test_helper'

class SpellsControllerTest < ActionDispatch::IntegrationTest
  include CommonCardControllerTest

  setup do
    @card = @spell = cards(:bane)
  end

  test 'show should' do
    get spell_path(@spell)
    assert_response :success
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Spell.count' do
      post spells_path, params: { spell: {description: "Woopsie"} }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'index should' do
    get spells_path
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Spell.count', +1 do
      source = sources(:dnd)
      get new_spell_path, headers: { "HTTP_REFERER" => spells_url }
      post spells_path,
           params: {
               spell: {
                   name: 'AAA',
                   source_id: source.id,
                   card_size: '25x50',
                   level: 2,
                   school: 'transmutation'
               }
           }
    end

    new_spell = Spell.find_by_name('AAA')
    assert new_spell
    assert_equal 2, new_spell.level

    assert_redirected_to spells_url
  end

  test 'should get update' do
    log_in_as(users(:michael))
    assert_no_difference 'Spell.count' do
      get edit_spell_path(@spell), headers: { "HTTP_REFERER" => spells_url }
      patch spell_path(@spell), params: { id: @spell.id, spell: {name: 'ABCD'} }
    end

    updated_spell = Spell.find(@spell.id)
    assert updated_spell
    assert_equal 'ABCD', updated_spell.name

    assert_redirected_to spells_url
  end

  test 'should redirect to index after destroy' do
    log_in_as(users(:michael))
    spell = cards(:fireball)
    assert_difference 'Spell.count', -1 do
      delete spell_path(spell), headers: { "HTTP_REFERER" => spells_url }
    end
    assert_redirected_to spells_url
  end

  test 'should redirect destroy for wrong spell' do
    log_in_as(users(:archer))
    spell = cards(:bane)
    assert_no_difference 'Spell.count' do
      delete spell_path(spell)
    end
    assert_redirected_to root_url
  end

  test 'should get duplicate' do
    log_in_as(users(:michael))
    spell = cards(:fireball)
    assert_difference 'Spell.count', +1 do
      post duplicate_spell_path(spell), headers: { "HTTP_REFERER" => spells_url }
    end
    assert_redirected_to spells_url

    duplicate = Spell.find_by_name "#{spell.name} (copy)"
    assert duplicate
    assert_equal users(:michael), duplicate.user
    assert_equal users(:archer), spell.user
  end
end
