require 'test_helper'

class SpellbooksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @spellbook = spellbooks(:orcspells)
  end

  test 'show should redirect when not logged in' do
    get spellbook_url(@spellbook)
    assert_redirected_to login_url
  end

  test 'new should redirect when not logged in' do
    get new_spellbook_url
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    get edit_spellbook_url(@spellbook)
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post spellbooks_url, params: { spellbook: { name: '' } }
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch spellbook_url(@spellbook)
    assert_redirected_to login_url
  end

  test 'destroy should redirect when not logged in' do
    delete spellbook_url(@spellbook)
    assert_redirected_to login_url
  end

  test 'spells should redirect when not logged in' do
    get spells_spellbook_path(@spellbook)
    assert_redirected_to login_url
  end

  test 'select should redirect when not logged in' do
    post select_spellbook_url(@spellbook)
    assert_redirected_to login_url
  end

  test 'inscribe should redirect when not logged in' do
    fireball = cards(:fireball)
    patch inscribe_spellbook_url(@spellbook), params: { spell_id: fireball.id }
    assert_redirected_to login_url
  end

  test 'erase should redirect when not logged in' do
    fireball = cards(:fireball)
    delete erase_spellbook_url(@spellbook), params: { spell_id: fireball.id }
    assert_redirected_to login_url
  end

  test 'should get index' do
    skip
    log_in_as(users(:michael))
    get spellbooks_url
    assert_response :success
  end

  test 'should get show' do
    skip
    log_in_as(users(:michael))
    get spellbook_url(@spellbook)
    assert_response :success
  end

  test 'should get new' do
    skip
    log_in_as(users(:michael))
    get new_spellbook_url
    assert_response :success
  end

  test 'should get create' do
    skip
    log_in_as(users(:michael))
    assert_difference 'Spellbook.count', +1 do
      post spellbooks_url, params: { spellbook: { name: 'AAA' } }
    end

    spellbook = Spellbook.find_by_name('AAA')
    assert spellbook

    assert_redirected_to spellbooks_url
  end

  test 'should get edit' do
    skip
    log_in_as(users(:michael))
    get edit_spellbook_url(@spellbook)
    assert_response :success
  end

  test 'should get update' do
    skip
    log_in_as(users(:michael))
    spellbook_name = 'aaaa'
    id = @spellbook.id
    assert_no_difference 'Spellbook.count' do
      patch spellbook_url(@spellbook), params: { spellbook: { name: spellbook_name } }
    end

    spellbook = Spellbook.find(id)
    assert spellbook
    assert_equal spellbook_name, spellbook.name

    assert_redirected_to spellbooks_path
  end

  test 'should get destory' do
    skip
    log_in_as(users(:michael))
    assert_difference 'Spellbook.count', -1 do
      delete spellbook_url(@spellbook)
    end
    assert_redirected_to spellbooks_url
  end

  test 'should select spellbook' do
    skip
    log_in_as(users(:michael))
    post select_spellbook_url(@spellbook)

    assert_equal@spellbook.id, session[:spellbook_id]
  end

  test 'should inscribe spell into spellbook' do
    skip
    log_in_as(users(:michael))
    post select_spellbook_url(@spellbook)
    fireball = cards(:fireball)

    patch inscribe_spellbook_url(@spellbook), params: { spell_id: fireball.id }, xhr: true

    spellbook = Spellbook.find(@spellbook.id)
    assert_includes spellbook.spells, fireball
    assert_equal 'text/javascript', @response.content_type
  end

  test 'should erase spell into spellbook' do
    skip
    log_in_as(users(:michael))
    post select_spellbook_url(@spellbook)
    fireball = cards(:fireball)

    delete erase_spellbook_url(@spellbook), params: { spell_id: fireball.id }, xhr: true

    spellbook = Spellbook.find(@spellbook.id)
    assert_not_includes spellbook.spells, fireball
    assert_equal 'text/javascript', @response.content_type
  end
end
