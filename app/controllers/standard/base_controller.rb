module Standard
  class BaseController < ApplicationController

    layout 'standard'

    before_action :authenticate!
    before_action :nav_setup

    private

    attr_reader :current_page
    helper_method :current_page

    def authenticate!
    	unless standard_access?
    		redirect_to new_session_path(redirect_to: request.fullpath)
    	end
    end

    def nav_setup
      @parts = Part.all.includes(:sections_by_position)
    end
  end
end
