module Admin
  class CardImportsController < ApplicationController
    layout 'admin'
    before_action :logged_in_user

    def new
      session[:card_import_params] ||= {}
      @card_import = CardImport.new
      @card_import.current_step = session[:import_step]
    end

    def create
      #session[:card_import_params].deep_merge!(params[:card_import].map {|k,v| [k, (v.is_a? String) ? v.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '_') : v]}) if params[:card_import]
      session[:card_import_params].deep_merge!(params[:card_import]) if params[:card_import]
      @card_import = CardImport.new(session[:card_import_params])
      @card_import.current_step = session[:import_step]
      if @card_import.last_step?
        @card_import.save(current_user)
      else
        @card_import.next_step
      end
      session[:import_step] = @card_import.current_step

      if @card_import.new_record?(current_user)
        render :new
      else
        session[:import_step] = session[:card_import_params] = nil
        redirect_to admin_import_path, notice: 'Imported products successfully.'
      end
    end

    def index
    end

    def show
      @card_export = CardExport.new

      case params[:id]
        when 'monsters'
          monsters_xml = @card_export.load_monsters(Monster.all)
          send_data monsters_xml, filename: 'monsters.xml', type: 'text/xml'
        when 'spells'
          spells_xml = @card_export.load_spells(Spell.all)
          send_data spells_xml, filename: 'spells.xml', type: 'text/xml'
        when 'items'
          items_xml = @card_export.load_items(Item.all)
          send_data items_xml, filename: 'items.xml', type: 'text/xml'
        else
          render :index
      end
    end
  end
end
