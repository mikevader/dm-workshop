module Admin
  class CardImportsController < ApplicationController
    layout 'admin'
    before_action :logged_in_user

    def new
      @card_import = CardImport.new
    end

    def index
    end

    def show
      @card_export = CardExport.new

      case params[:id]
        when 'monsters'
          monsters_xml = @card_export.load_monsters(Monster.all)
          send_data monsters_xml, filename: 'monsters.xml', type: 'text/xml'
        else
          render :index
      end
    end

    def create
      @card_import = CardImport.new(params[:card_import])
      if @card_import.save(current_user)
        redirect_to admin_import_path, notice: "Imported products successfully."
      else
        render :new
      end
    end
  end
end