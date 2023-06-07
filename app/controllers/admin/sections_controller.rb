module Admin
  class SectionsController < BaseController
    before_action :nav_setup

    def index
      result = Section::Index.(params)

      if result.success?
        render locals: {
          form: result["contract.default"],
          sections: result["sections"]
        }
      else
        handle_standard_failure(result["failure"])
      end
    end

    def create
      result = Section::Create.(params)

      if result.success?
        render json: {
          section: render_to_string(template: "admin/sections/_section", layout: false, locals: {
            section: result["model"]
          })
        }
      else
        render json: {
          section: render_to_string(template: "admin/sections/_section_form", layout: false, locals: {
            form: result["contract.default"],
            error: result["failure"].message
          })
        }
      end
    end

    def edit
      result = Section::Edit.(params)

      if result.success?
        render locals: {
          form: result["contract.default"]
        }
      else
        handle_standard_failure(result["failure"])
      end
    end

    def update
      result = Section::Update.(params)

      if result.success?
        redirect_to edit_admin_part_section_path
      else
        handle_standard_failure(result["failure"], locals: { form: result["contract.default"] })
      end
    end

    def destroy
      result = Section::Destroy.(params)

      if result.success?
        flash[:notice] = "Successfully deleted #{result['section'].title}"
        redirect_to admin_part_sections_path
      else
        handle_standard_failure(result["failure"])
      end
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
