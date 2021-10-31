module Standard
	class SectionsController < BaseController
	  def index
	    part = Part.find(params[:part_id])
	    
	    redirect_to part_path(part)
	  end

	  def show
	    result = Section::Show.(params)
	    @current_page = result['section']

	    if result.success?
	      render locals: {
	        text: result['text']
	      }
	    else
	      render result['failure'].go_to, locals: {text: result['failure'].detail}
	    end
	  end
	end
end