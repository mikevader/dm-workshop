class SpellbooksController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :edit, :update, :create, :destroy, :spells, :inscribe, :erase, :select]
  autocomplete :spell, :name, full: true

  def index
    @spellbooks = policy_scope(Spellbook).all
  end

  def show
    @spellbook = Spellbook.find(params[:id])
    authorize @spellbook
    @spells = @spellbook.spells
    authorize @spells
  end

  def new
    authorize Spellbook
    @spellbook = current_user.spellbooks.build
  end

  def create
    @spellbook = current_user.spellbooks.build(spellbook_params)
    authorize @spellbook
    if @spellbook.save
      flash[:success] = 'Spellbook created!'
      redirect_to spellbooks_path
    else
      render 'new'
    end
  end

  def edit
    @spellbook = Spellbook.find(params[:id])
    authorize @spellbook
  end

  def update
    @spellbook = Spellbook.find(params[:id])
    authorize @spellbook
    if @spellbook.update_attributes(spellbook_params)
      flash[:success] = 'Spellbook updated!'
      redirect_to spellbooks_path
    else
      render 'edit'
    end
  end

  def destroy
    spellbook = Spellbook.find(params[:id])
    authorize spellbook
    spellbook.destroy
    flash[:success] = 'Spellbook deleted!'
    redirect_to spellbooks_path
  end

  def select
    if params[:id].to_i < 0
      deselect_spellbook
      flash[:success] = 'Spellbook deselected'
    else
      spellbook = Spellbook.find(params[:id])
      authorize spellbook
      select_spellbook(spellbook)
      flash[:success] = "Select Spellbook: #{current_spellbook.name}"
    end
    redirect_to spells_path
  end

  def spells
    @spellbook = Spellbook.find(params[:id])
    @spells = @spellbook.spells
  end

  def inscribe
    authorize current_spellbook

    @spell = Spell.find(params[:spell_id])
    current_spellbook.inscribe(@spell)
    respond_to do |format|
      format.html { redirect_to @spell}
      format.js
    end
  end

  def erase
    authorize current_spellbook

    @spell = Spell.find(params[:spell_id])
    current_spellbook.erase(@spell)
    respond_to do |format|
      format.html { redirect_to @spell}
      format.js
    end
  end

  private
  def spellbook_params
    params.require(:spellbook).permit(:name, :spells, :spell_ids => [])
  end
end
