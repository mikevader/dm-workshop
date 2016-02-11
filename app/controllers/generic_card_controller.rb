require 'search_engine'

class GenericCardController < ApplicationController
  layout :choose_layout
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :init_search_engine, only: [:index]

  def init_search_engine
    @search_engine = SearchEngine2.new(controller_name.classify.constantize)
  end

  def search_engine
    @search_engine
  end

  private
  # Select the layout depending on the CRUD mode
  def choose_layout
    case action_name
      when 'index'
        return 'card_index'
      when 'edit'
        return 'card_edit'
      when 'new'
        return 'card_new'
      else
        return nil
    end
  end
end