class CardsController < ApplicationController
  include ColumnsHelper

  helper_method :card_model, :print_path, :search_path, :new_path, :edit_path, :duplicate_path, :spell_card?
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy]
  before_action :init_search_engine, only: [:index]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def init_search_engine
    @search_engine = Search::SearchEngine.new(policy_scope(card_model))
  end

  # Create actions
  def new
    authorize card_model
    @card = user_collection.build
    session[:return_to] = request.referer
  end

  def create
    ttt = card_params
    ttt[:type] = card_model.to_s
    @card = current_user.cards.build(ttt)
    authorize @card
    if @card.save
      flash[:success] = 'Card created!'
      redirect_to session.delete(:return_to) || root_path
    else
      render 'new'
    end
  end

  def preview
    card_data = nil
    ActiveRecord::Base.transaction do
      ttt = card_params
      if Card.exists?(params[:id].to_i)
        card = Card.find(params[:id])
      else
        card_type = card_model.to_s
        ttt[:type] = card_type
        card = current_user.cards.build(type: card_type)
      end
      authorize card
      card.assign_attributes(ttt)

      card.save(validate: false)
      card.reload

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

  def duplicate
    @card = Card.find(params[:id]).replicate
    authorize @card
    @card.user = current_user
    @card.name = @card.name + ' (copy)'
    if @card.save
      flash[:success] = 'Card duplicated!'
      redirect_to request.referer || root_path
    else
      render 'new'
    end
  end

  # Read actions
  def index
    authorize card_model
    result, normalized, error = search_engine.search(params[:search])

    params[:search] = normalized

    @cards = result
    @error = error
    #@cards.each {|card| authorize card}
  end

  def show
    authorize card_model
    @card = card_model.find(params[:id])
    authorize @card
  end

  # Update actions
  def edit
    @card = card_model.find(params[:id])
    authorize @card
    session[:return_to] = request.referer
  end

  def update
    @card = Card.find(params[:id])
    authorize @card
    if @card.update(card_params)
      flash[:success] = 'Card updated!'
      redirect_to session.delete(:return_to) || root_path
    else
      render 'edit'
    end
  end

  # Delete actions
  def destroy
    card = Card.find(params[:id])
    authorize card
    card.destroy
    flash[:success] = 'Card deleted'
    redirect_to request.referer || root_path
  end

  private
  def user_collection
    current_user.send(controller_name)
  end

  def card_model
    controller_name.classify.constantize
  end

  def card_type
    controller_name.classify.parameterize.underscore.to_sym
  end

  def spell_card?
    card_model == Spell
  end

  def search_engine
    @search_engine
  end

  def card_params(type = card_type)
    common_fields = [:name, :source_id, :card_size, :shared, :cite, :tag_list]
    case type
      when :freeform
        params.require(:free_form).permit(common_fields, :icon, :color, :contents)
      when :item
        params.require(:item).permit(common_fields, :cssclass, :category_id, :rarity_id, :attunement, :description, properties_attributes: [:id, :name, :value, :position, :_destroy])
      when :monster
        params.require(:monster).permit(common_fields, :monster_size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :senses, :languages, :challenge, :description, :skills, :saving_throws => [], :damage_vulnerabilities => [], :damage_resistances => [], :damage_immunities => [], :cond_immunities => [], actions_attributes: [:id, :title, :description, :action_type, :melee, :ranged, :position, :_destroy], traits_attributes: [:id, :title, :description, :position, :_destroy], cards_skills_attributes: [:id, :skill_id, :value, :_destroy])
      when :spell
        params.require(:spell).permit(common_fields, :ritual, :level, :school, :casting_time, :range, :components, :duration, :short_description, :athigherlevel, :description, :picture, :concentration, :hero_classes, :hero_class_ids => [])
    end
  end
end
