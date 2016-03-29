module CardsHelper
  def modal_size(cards)
    card_size = largest(cards)
    has_description = cards.reduce(false) { |r, e| r || has_description?(e) }

    if has_description
      'modal-lg'
    else
      if card_size == '35x50'
        ''
      else
        'modal-sm'
      end
    end
  end

  def has_description?(card)
    !card.card_data.description.blank?
  end

  def largest(cards)
    cards.map { |card| card.card_data }.inject { |largest, card| larger_of(largest, card.card_size) }
  end

  def larger_of(one, two)
    if one == '35x50'
      one
    elsif two == '35x50'
      two
    else
      '25x35'
    end
  end
end
