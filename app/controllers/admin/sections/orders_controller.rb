module Admin
	module Sections
		class OrdersController < BaseController

	    def update
	    	result = SectionOrder::Update.(params)

	    	if result.success?
	    		render 200
	    	else
	    		render json: {
	    			error: result['failure'].message
	    		}, status: 400
	    	end
	    end

	  end
  end
end
