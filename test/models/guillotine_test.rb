require 'test_helper'

class GuillotineTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  setup do
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
  end

  # Fake test
  def test_ten_small_cards_on_two_pages
    cards = []
    10.times do |i|
      cards << Card.new(card_size: '25x35')
    end

    pages = Guillotine.insert(cards)

    assert_not_nil pages
    assert_kind_of Array, pages
    assert_equal 2, pages.size
    assert_equal 9, pages.first.card_nodes.size
    assert_equal 1, pages.second.card_nodes.size

    pages.each do |page|
      assert no_intersections(page)
      assert all_inside_page(page)
    end
  end

  def test_big_and_small_cards
    cards = []
    cards << Card.new(card_size: '50x70')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '50x70')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')

    pages = Guillotine.insert(cards)

    assert_not_nil pages
    assert_kind_of Array, pages
    assert_equal 3, pages.size
    assert_equal 6, pages.first.card_nodes.size
    assert_equal 6, pages.second.card_nodes.size
    assert_equal 1, pages.third.card_nodes.size

    pages.each do |page|
      assert no_intersections(page)
      assert all_inside_page(page)
    end
  end

  def test_big_medium_and_small_cards
    cards = []
    cards << Card.new(card_size: '50x70')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '35x50')
    cards << Card.new(card_size: '50x70')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')
    cards << Card.new(card_size: '25x35')

    pages = Guillotine.insert(cards)

    assert_not_nil pages
    assert_kind_of Array, pages
    assert_equal 3, pages.size
    assert_equal 5, pages.first.card_nodes.size
    assert_equal 6, pages.second.card_nodes.size
    assert_equal 2, pages.third.card_nodes.size

    pages.each do |page|
      assert no_intersections(page)
      assert all_inside_page(page)
    end
  end

  def no_intersections(page)
    nodes = page.card_nodes
    nodes.each_with_index do |item_a, index|
      nodes.drop(index + 1).each do |item_b|
        if item_a.intersects? item_b
          return false
        end
      end
    end

    return true
  end

  def all_inside_page(page)
    nodes = page.card_nodes
    nodes.each_with_index do |item_a, index|
      unless item_a.inside?(page)
        return false
      end
    end

    return true
  end
end
