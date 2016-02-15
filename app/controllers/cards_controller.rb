require 'search_engine'

class CardsController < GenericCardController

  def create
    @card = current_user.cards.build(card_params)
    authorize @card
    if @card.save
      flash[:success] = 'Card created!'
      redirect_to cards_url
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Card.find(params[:id]).replicate
    authorize @card
    @card.user = current_user
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Card duplicated!"
      redirect_to cards_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def update
    @card = Card.find(params[:id])
    authorize @card
    if @card.update_attributes(card_params)
      flash[:success] = 'Card updated!'
      redirect_to cards_url
    else
      render 'edit', layout: 'card_edit'
    end
  end

  def destroy
    card = Card.find(params[:id])
    authorize card
    card.destroy
    flash[:success] = 'Card removed!'
    redirect_to cards_url
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      card = nil
      if Card.exists?(params[:id])
        card = Card.find(params[:id])
      else
        card = current_user.cards.build
      end
      authorize card
      card.assign_attributes(card_params)
      card_data = card.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: {card: card_data}
  end

  def modal
    card = Card.find(params[:id])
    authorize card
    render partial: 'shared/modal_body', locals: {card: card, index: params[:index], modal_size: params[:modal_size], prev_index: params[:previd], next_index: params[:nextid]}
  end

  private
  def card_params
    params.require(:card).permit(:name, :tag_list, :icon, :color, :contents)
  end

  def new_path
    new_card_path
  end
end
