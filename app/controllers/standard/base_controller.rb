module Standard
  class BaseController < ApplicationController

    layout 'standard'

    before_action :authenticate!

    private

    def authenticate!
    	unless standard_access?
    		redirect_to new_session_path(redirect_to: request.fullpath)
    	end
    end

  end
end
