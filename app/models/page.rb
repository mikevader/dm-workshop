class Page
  include ActiveModel::Model

  attr_accessor :width
  attr_accessor :height
  attr_accessor :tree

  def initialize(width, height)
    self.width = width
    self.height = height
    self.tree = Node.new(0, 0, self.width, self.height)
  end

  def insert(card)
    return tree.insert(card)
  end

  def to_a
    return tree.to_a.flatten
  end

  def card_nodes
    return to_a.select{|node| node.card }
  end

  def cards
    return card_nodes.map{|node| node.card}
  end
end
