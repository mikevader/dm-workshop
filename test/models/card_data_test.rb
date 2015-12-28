class CardDataTest < ActiveSupport::TestCase


  test 'should work with a single element' do
    data = CardData.new

    data.add_subtitle ['hello']

    first = data.contents.first

    assert first.subtitle?
    assert_equal 'hello', first.args.first

    assert_not first.rule?
  end

  test 'should work with a multiple elements' do
    data = CardData.new

    data.add_subtitle ['hello']
    data.add_description %w(title description)
    data.add_boxes [9, 2]
    data.add_property %w(size medium)

    first = data.contents.first
    assert first.subtitle?
    assert_equal 'hello', first.args.first

    second = data.contents.second
    assert second.description?
    assert_equal 'title', second.args.first
    assert_equal 'description', second.args.second

    third = data.contents.third
    assert third.boxes?
    assert_equal 9, third.args.first
    assert_equal 2, third.args.second

    fourth = data.contents.fourth
    assert fourth.property?
    assert_equal 'size', fourth.args.first
    assert_equal 'medium', fourth.args.second


  end

end