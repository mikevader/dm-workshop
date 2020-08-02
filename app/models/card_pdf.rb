require 'render_anywhere'

class CardPdf
  include RenderAnywhere

  def initialize(pages)
    @pages = pages
  end

  def to_pdf
    kit = PDFKit.new(as_html, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/card.pdf")
  end

  def filename
    "card.pdf"
  end

  private

  attr_reader :pages

  def as_html
    render template: 'downloads/all', layout: 'print', locals: { pages: pages }
  end
end