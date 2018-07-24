module Admin
  class SectionsController < ApplicationController

    def index
      result = Section::Index.(params)

      if result.success?
        render locals: {
          form: result['contract.default']
        }
      else
        handle_standard_failure(result['failure'])
      end
    end

    def create
      result = Section::Create.(params)

      if result.success?
        render json: {
          section: render_to_string(template: 'admin/sections/_section', layout: false, locals: {
            section: result['model']
          })
        }
      else
        binding.pry
        render json: {
          section: render_to_string(template: 'admin/sections/_form', layout: false, locals: {
            form: result['contract.default'],
            error: result['failure'].message
          })
        }
      end
    end

  end
end
