class Section::Destroy < Trailblazer::Operation

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  step :section
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find section with ID #{params[:id]}",
      go_to: url_helpers.admin_part_sections_path(part_id: params[:part_id]),
      step: 'model'
    }
  }

  step :destroy
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Something went wrong. Please try again",
      go_to: url_helpers.admin_part_sections_path(part_id: params[:part_id]),
      step: 'destroy'
    }
  }

  def section(options, params:, **)
    options['section'] = Section.find_by(id: params[:id])
  end

  def destroy(options, params:, **)
    options['section'].destroy
  end

end
