module Admin
  class SectionsController < BaseController

    def index
      result = Section::Index.(params)

      if result.success?
        render locals: {
          form: result['contract.default'],
          sections: result['sections']
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
        render json: {
          section: render_to_string(template: 'admin/sections/_form', layout: false, locals: {
            form: result['contract.default'],
            error: result['failure'].message
          })
        }
      end
    end

    def edit
      result = Section::Edit.(params)

      if result.success?
        render locals: {
          form: result['contract.default']
        }
      else
        handle_standard_failure(result['failure'])
      end
    end

    def update
      result = Section::Update.(params)

      if result.success?
        redirect_to edit_admin_part_section_path
      else
        handle_standard_failure(result['failure'], locals: {form: result['contract.default']})
      end
    end

  end
end
