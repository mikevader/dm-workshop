module CommonCardTest
  extend ActiveSupport::Concern
  included do
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

    test 'name should be no longer than 50 characters' do
      @card.name = 'q' * 51
      assert_not @card.valid?
    end

    test 'names should be unique' do
      duplicate_item = @card.dup
      duplicate_item.name = @card.name.upcase
      @card.save
      assert_not duplicate_item.valid?
    end

    test 'source should be present' do
      @card.source = nil
      assert_not @card.valid?
    end

    test 'replicate should work with tags as well' do
      @card.tag_list.add('dsa')
      @card.save
      @card.reload

      replicate = @card.replicate
      assert_includes replicate.tag_list, 'dsa'
    end

  end
end