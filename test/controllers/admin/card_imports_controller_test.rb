require 'test_helper'

module Admin
  class CardImportsControllerTest < ActionController::TestCase

    setup do
      @user = users(:michael)
    end

    test 'should get import' do
      log_in_as @user
      get :new
      assert_response :success
    end

    test 'should get export' do
      log_in_as @user
      get :index
      assert_response :success
    end

    test 'monster card import' do
      log_in_as(@user)

      assert_difference 'Monster.count', 2 do
        post :create, card_import: { monsters_file: fixture_file_upload('monsters.xml', 'text/xml') }
        post :create, imports: [{import: true, name: 'Goblin'}, {import: true, name: 'Obgam Sohn des Brogar'}]
      end

      goblin = Monster.find_by_name 'Goblin'
      assert goblin
      obgam = Monster.find_by_name 'Obgam Sohn des Brogar'
      assert obgam
    end

    test 'spell card import' do
      log_in_as(@user)

      assert_difference 'Spell.count', 2 do
        post :create, card_import: { spells_file: fixture_file_upload('spells.xml', 'text/xml') }
        post :create, imports: [{import: true, name: 'Antilife Shell'}, {import: true, name: 'Magic Missile'}]
      end

      magic_missile = Spell.find_by_name 'Magic Missile'
      assert magic_missile
      antilife_shell = Spell.find_by_name 'Antilife Shell'
      assert antilife_shell
    end

    test 'item card import' do
      log_in_as(@user)

      assert_difference 'Item.count', 2 do
        post :create, card_import: { items_file: fixture_file_upload('items.xml', 'text/xml') }
        post :create, imports: [{import: true, name: 'Schutzring'}, {import: true, name: 'Speer des Blitzes'}]
      end

      schutzring = Item.find_by_name 'Schutzring'
      assert schutzring
      speer = Item.find_by_name 'Speer des Blitzes'
      assert speer
    end

    test 'monsters card export' do
      log_in_as(@user)

      get :show, id: 'monsters'
      assert_response :success
      assert_equal 'text/xml', response.content_type #response.body
    end

    test 'spells card export' do
      log_in_as(@user)

      get :show, id: 'spells'
      assert_response :success
      assert_equal 'text/xml', response.content_type #response.body
    end

    test 'items card export' do
      log_in_as(@user)

      get :show, id: 'items'
      assert_response :success
      assert_equal 'text/xml', response.content_type #response.body
    end

  end
end
