module Standard
  class BaseController < ApplicationController

    layout 'standard'

    before_action :authenticate!
    before_action :nav_setup

    private

    def authenticate!
    	unless standard_access?
    		redirect_to new_session_path(redirect_to: request.fullpath)
    	end
    end

    def nav_setup
      @parts = Part.all
    end

    def current_section
      @current_section ||= Section.find_by(id: params[:id])
    end
    helper_method :current_section

  end
end
