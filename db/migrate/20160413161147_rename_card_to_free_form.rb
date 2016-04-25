class RenameCardToFreeForm < ActiveRecord::Migration
  def up
    Card.where(type: 'Card').find_each do |card|
      card.type = 'FreeForm'
      card.save
    end
  end

  def down
    Card.where(type: 'FreeForm').find_each do |card|
      card.type = 'Card'
      card.save
    end
  end
end
