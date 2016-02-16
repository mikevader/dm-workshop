class MonstersController < GenericCardController

  def create
    @card = current_user.monsters.create(monster_required_params)
    authorize @card
    if @card.update_attributes(monster_params)
      flash[:success] = "Monster bread!"
      redirect_to monsters_path
    else
      render 'new', layout: 'card_new'
    end
  end

  def duplicate
    @card = Monster.find(params[:id]).replicate
    authorize @card
    @card.user = current_user
    @card.name = @card.name + " (copy)"
    if @card.save
      flash[:success] = "Monster cloned!"
      redirect_to monsters_path
    else
      render 'new', layout: 'card_new'
    end
  end
  
  def update
    @card = Monster.find(params[:id])
    authorize @card
    if @card.update_attributes(monster_params)
      flash[:success] = "Monster evolved!"
      redirect_to monsters_path
    else
      render 'edit', layout: 'card_edit'
    end
  end
  
  def destroy
    card = Monster.find(params[:id])
    authorize card
    card.destroy
    flash[:success] = "Monster killed!"
    redirect_to monsters_url
  end

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
  def monster_required_params
    params.require(:monster).permit(:name, :tag_list, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma)
  end
  def monster_params
    params.require(:monster).permit(:name, :shared, :tag_list, :cite, :size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :senses, :languages, :challenge, :description, :skills, :saving_throws => [], :damage_vulnerabilities => [], :damage_resistances => [], :damage_immunities => [], :cond_immunities => [], :monsters_skills_ids => [], :skill_ids => [], actions_attributes: [:id, :title, :description, :action_type, :melee, :ranged, :_destroy], traits_attributes: [:id, :title, :description, :_destroy], monsters_skills_attributes: [:id, :skill_id, :value, :_destroy])
  end

  def correct_user
    @card = Monster.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@card.user) || admin_user?
  end

  def new_path
    new_monster_path
  end
end
