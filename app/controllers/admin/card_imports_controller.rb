module Admin
  class CardImportsController < ApplicationController
    layout 'admin'
    before_action :logged_in_user

    def new
      session[:card_import_params] ||= []
      @card_import = CardImport.new current_user
      @card_import.current_step = session[:import_step]
      @card_import.imports = session[:card_import_selects]
    end

    def create
      if params[:card_import]
        @card_import = CardImport.new(current_user, params[:card_import])

        @card_import.import_files

        session[:card_import_selects] = @card_import.imports.sort! { |a, b| a.name.downcase <=> b.name.downcase }

      else
        @card_import = CardImport.new(current_user)
        @card_import.current_step = session[:import_step]
        @card_import.imports = session[:card_import_selects]

        if params[:imports]
          existing = @card_import.imports.sort { |a, b| a.name.downcase <=> b.name.downcase }
          imports = params[:imports].values.sort { |a, b| a[:name].downcase <=> b[:name].downcase }

          imports.zip(existing).each do |imp, card|
            card.import = imp[:import]
            #card.id = imp[:id]
            card.name = imp[:name]
          end
        end
      end

      if @card_import.last_step?
        @card_import.save
      else
        @card_import.next_step
      end
      session[:import_step] = @card_import.current_step

      if @card_import.new_record?
        render :new
      else
        session[:import_step] = session[:card_import_selects] = nil
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

    def destroy
      session[:import_step] = nil
      session[:card_import_selects] = nil
      redirect_to admin_import_path
    end
  end
end
