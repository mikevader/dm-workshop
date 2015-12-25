module Admin
  class AdminController < ApplicationController
    layout 'admin'
    before_action :logged_in_user


    def home
    end

    def import
    end
  end
end
