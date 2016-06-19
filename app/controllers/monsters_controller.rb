class MonstersController < CardsController

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      if Monster.exists?(params[:id].to_i)
        monster = Monster.find(params[:id])
      else
        monster = current_user.monsters.build
      end
      authorize monster
      monster.assign_attributes(monster_params)
      card_data = monster.card_data
      raise ActiveRecord::Rollback, "Don't commit preview data changes!"
    end
    render partial: 'shared/card_card', locals: { card: card_data}
  end

  def modal
    card = Monster.find(params[:id])
    authorize card
    render partial: 'shared/modal_body', locals: { card: card, index: params[:index], modal_size: params[:modal_size], prev_index: params[:previd], next_index: params[:nextid] }
  end

  private
  def correct_user
    @card = Monster.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@card.user) || admin_user?
  end

  def new_path
    new_monster_path
  end

  def search_path
    monsters_path
  end

  def print_path(*search_args)
    print_monsters_path(search_args)
  end
end
