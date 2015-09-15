class OutputPagesController < ApplicationController
  layout 'print'
  def spells
    begin
      if params[:search].blank?
        @spells = Spell.all
      else
        @spells = Spell.search(params[:search])
      end

      @spells = @spells.paginate(page: params[:page]).order(:name)
    rescue ParseSearchError => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      flash.now[:danger] = e.message
      @spells = Spell.none.paginate(page: params[:page])
    end
  end
  
  def items
    begin
      if params[:search].blank?
        @items = Item.all
      else
        @items = Item.search(params[:search])
      end
      @items = @items.paginate(page: params[:page]).order(:name)
    rescue ParseSearchError => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      flash.now[:danger] = e.message
      @spells = Spells.none.paginate(page: params[:page])
    end
  end
end
