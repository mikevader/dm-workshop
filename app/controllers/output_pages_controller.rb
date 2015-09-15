class OutputPagesController < ApplicationController
  layout 'print'
  def spells
    if params[:search].blank?
      @spells = Spell.all
    else
      @spells = Spell.search(params[:search])
    end
    
    @spells = @spells.paginate(page: params[:page]).order(:name)
  rescue Exception => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    flash.now[:danger] = e.message
    @spells = Spell.none.paginate(page: params[:page])
  end
  
  def items
    @items = Item.all
  end
end
