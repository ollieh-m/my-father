module Admin
	module Sections
		class OrdersController < BaseController

	    def update
	      # get part
	      # get array of sections - check sections are from the part
	      # check there are no other sections
	      # update the order of each section
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
