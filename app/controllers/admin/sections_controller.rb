module Admin
  class SectionsController < ApplicationController

    def index
      render locals: {
        new_section: Section.new
      }
    end

    def create
      result = Section::Create.(params)

      if result.success?
        render json: {
          section: render_to_string(template: 'admin/sections/_section', layout: false, locals: {section: result['model']} )
        }
      else
        # render form partial showing errors, which may be written directly to a failure explanation key
      end
    end

  end
end
