module Standard
	class SectionsController < BaseController

	  def index
	    part = Part.find_by(id: params[:part_id])
	    if part && first_section = part.sections_by_position.first
	      redirect_to part_section_path(part_id: part, id: first_section)
	    end
	  end

	  def show
	  	@current_page = Section.find_by(id: params[:id])

	    result = Section::Show.(params)

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