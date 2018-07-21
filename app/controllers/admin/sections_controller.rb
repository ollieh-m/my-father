module Admin
  class SectionsController < ApplicationController

    def index
      render locals: {
        new_section: Section.new
      }
    end

    def create
      # use a form to validate submission
      section = Section.create(part: part, title: section_params[:title])

      render json: {
        section: render_to_string(template: 'admin/sections/_section', layout: false, locals: {section: section} )
      }
    end

    def section_params
      params.require(:section).permit(:title)
    end

    def part
      Part.find(params[:part_id])
    end

  end
end
