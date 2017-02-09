class Node
  include ActiveModel::Model

  attr_accessor :width
  attr_accessor :height
  attr_accessor :x
  attr_accessor :y

  attr_accessor :left
  attr_accessor :right
  attr_accessor :card
  attr_accessor :rotated

  def initialize(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  end

  def insert(card)
    if left || right
      if left && newNode = left.insert(card)
        return newNode
      end

      if right && newNode = right.insert(card)
        return newNode
      end

      return nil
    end

    unless card_fits_portrait?(card) || card_fits_landscape?(card)
      return nil
    end


    if card_fits_portrait?(card)
      rotated = false
      card_width = card.width
      card_height = card.height
    else
      rotated = true
      card_width = card.height
      card_height = card.width

    end
    remainWidth = width - card_width
    remainHeight = height - card_height

    if remainWidth <= remainHeight
      leftx = x + card_width
      lefty = y
      leftw = remainWidth
      lefth = card_height

      rightx = x
      righty = y + card_height
      rightw = width
      righth = remainHeight
    else
      leftx = x
      lefty = y + card_height
      leftw = card_width
      lefth = remainHeight

      rightx = x + card_width
      righty = y
      rightw = remainWidth
      righth = height
    end

    self.left = Node.new(leftx, lefty, leftw, lefth)
    self.right = Node.new(rightx, righty, rightw, righth)
    self.width = card_width
    self.height = card_height
    self.card = card
    self.rotated = rotated

    return self
  end

  def card_fits_portrait?(card)
    (card.width <= width && card.height <= height)
  end

  def card_fits_landscape?(card)
    (card.height <= width && card.width <= height)
  end

  def to_a
    if left || right
      return [self, left.to_a, right.to_a]
    else
      return [self]
    end
  end

  def is_portrait?
    !rotated
  end

  def intersects?(node)
    ax1 = x
    ay1 = y
    ax2 = x + width
    ay2 = y + height

    bx1 = node.x
    by1 = node.y
    bx2 = node.x + node.width
    by2 = node.y + node.height

    return (ax1 < bx2 && ax2 > bx1 && ay1 < by2 && ay2 > by1)
  end

  def inside?(page)
    x2 = x + width
    y2 = y + height
    return (0 <= x && x < page.width && 0 < x2 && x2 <= page.width) &&
        (0 <= y && y < page.height && 0 < y2 && y2 <= page.height)
  end

end
