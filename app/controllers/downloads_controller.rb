
class DownloadsController < ApplicationController
  layout 'print'
  before_action :logged_in_user
  helper DownloadsHelper

  def show
    respond_to do |format|
      format.pdf do
        #send_card_pdf
        render pdf: 'all.pdf', template: 'downloads/all', layout: 'print', locals: { pages: pages }
      end

      if Rails.env.development?
        format.html { render_sample_html }
      end
    end
  end

  private

  def pages
    search_engine = Search::SearchEngine.new(policy_scope(Card))
    result, _normalized, _error = search_engine.search("name ~ 'wall'", false)

    Guillotine.insert(result)
  end

  def card_pdf
    hello = render_sample_html.first
    kit = PDFKit.new(hello, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/card.pdf")
  end

  def send_card_pdf
    send_file card_pdf,
              filename: 'hello.pdf',
              type: 'application/pdf',
              disposition: 'inline'
  end

  def render_sample_html
    render template: 'downloads/all', layout: 'print', locals: { pages: pages }
  end
end
