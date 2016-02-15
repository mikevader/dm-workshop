require 'search_engine'

class ItemsController < GenericCardController

  def create
    @card = current_user.items.build(item_params)
    authorize @card
    if @card.save
      flash[:success] = "Item crafted!"
      redirect_to items_url
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Item.find(params[:id]).replicate
    authorize @card
    @card.user = current_user
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Item replicated!"
      redirect_to items_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def update
    @card = Item.find(params[:id])
    authorize @card
    if @card.update_attributes(item_params)
      flash[:success] = "Item udpated"
      redirect_to items_url
    else
      render 'edit', layout: 'card_edit'
    end
  end
  
  def destroy
    card = Item.find(params[:id])
    authorize card
    card.destroy
    flash[:success] = "Item deleted"
    redirect_to items_url
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      if Item.exists?(params[:id].to_i)
        item = Item.find(params[:id])
      else
        item = current_user.items.build
      end
      authorize item
      item.assign_attributes(item_params)
      card_data = item.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data}
  end

  def modal
    card = Item.find(params[:id])
    authorize card
    render partial: 'shared/modal_body', locals: { card: card, index: params[:index], modal_size: params[:modal_size], prev_index: params[:previd], next_index: params[:nextid] }
  end

  private
  def item_params
    params.require(:item).permit(:name, :tag_list, :cssclass, :category_id, :rarity_id, :attunement, :description, properties_attributes: [:id, :name, :value, :_destroy])
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def new_path
    new_item_path
  end
end
