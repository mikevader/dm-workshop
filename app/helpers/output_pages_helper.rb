module OutputPagesHelper
  def card_style(card_node)
    card = card_node.card

    if card_node.is_portrait?
      top = card_node.y
      left = card_node.x
    else
      top = card_node.y - (card_node.width - card_node.height).abs/2.0
      left = card_node.x + (card_node.width - card_node.height).abs/2.0
    end


    style = "position: absolute; top: #{top}mm; left: #{left}mm;"


    unless card_node.is_portrait?
      style += " -webkit-transform: rotate(-90deg);"
      style += " -moz-transform: rotate(-90deg);"
      style += " transform: rotate(-90deg);"
    end

    return style
  end
end
