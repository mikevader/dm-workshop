class SpellbooksController < ApplicationController
  def index
    @spellbooks = Spellbook.all
  end

  def show
    @spellbook = Spellbook.find(params[:id])
    @spells = @spellbook.spells
  end

  def new
    @spellbook = current_user.spellbooks.build
  end

  def create
    @spellbook = current_user.spellbooks.build(spellbook_params)
    if @spellbook.save
    else
      render 'new'
    end
  end

  def edit
    @spellbook = Spellbook.find(params[:id])
  end

  def update
    @spellbook = Spellbook.find(params[:id])
    if @spellbook.update_attributes(spellbook_params)
    else
      render 'edit'
    end
  end

  def delete
    spellbook = Spellbook.find(params[:id])
    spellbook.destroy
  end

  private
  def spellbook_params
    params.require(:spellbook).permit(:name)
  end
end
