class Guillotine
  include ActiveModel::Model

  def self.insert(cards = [])

    cards = cards.sort{|a,b| (a.height*a.width) <=> (b.height*b.width)}.reverse
    #cards.each_with_index {|x,i| x.name = "#{x.name} #{i}"}

    pages = []
    pages << Page.new(197, 275)

    for card in cards do
      unless insert_in_pages(pages, card)
        pages << Page.new(197, 275)
        pages.last.insert(card)
      end
    end

    return pages
  end

  def self.insert_in_pages(pages, card)
    for page in pages do
      if page.insert(card)
        return card
      end
    end

    return nil
  end
end
