module Standard
	class SectionsController < BaseController

	  before_action :nav_setup

	  def index
	    part = Part.find_by(id: params[:part_id])
	    if part && first_section = part.sections.first
	      redirect_to part_section_path(part_id: part, id: first_section)
	    end
	  end

	  def show
	    result = Section::Show.(params)

	    if result.success?
	      render locals: {
	        text: result['text']
	      }
	    else
	      render result['failure'].go_to, locals: {text: result['failure'].detail}
	    end
	  end

	  private

	  def nav_setup
	    @parts = Part.all
	  end

	  def current_section
	    @current_section ||= Section.find_by(id: params[:id])
	  end
	  helper_method :current_section

	  def initial_load?
	  	/\/parts\/\d+\/sections\/\d+/.match(request.referer).nil?
	  end
	  helper_method :initial_load?

	end
end