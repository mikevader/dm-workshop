class SpellbooksController < ApplicationController
  autocomplete :spell, :name, full: true

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
      flash[:success] = 'Spellbook created!'
      redirect_to spellbooks_path
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
      flash[:success] = 'Spellbook updated!'
      redirect_to spellbooks_path
    else
      render 'edit'
    end
  end

  def destroy
    spellbook = Spellbook.find(params[:id])
    spellbook.destroy
    flash[:success] = 'Spellbook deleted!'
    redirect_to spellbooks_path
  end

  private
  def spellbook_params
    params.require(:spellbook).permit(:name, :spells, :spell_ids => [])
  end
end
