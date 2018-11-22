module Admin
	module Sections
		class OrdersController < BaseController

	    def update
	      binding.pry
	    end

	    private

	    def nav_setup
	      @parts = Part.all
	    end

	    def current_part
	      @current_part ||= Part.find_by(id: params[:part_id])
	    end
	    helper_method :current_part

	  end
  end
end
